# lambda/main.py
import json
import logging
import os
import boto3
from botocore.exceptions import ClientError

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize SNS client
sns_client = boto3.client('sns')

# Get SNS topic ARN from environment variable
SNS_TOPIC_ARN = os.environ.get('SNS_TOPIC_ARN')


def publish_to_sns(subject, message):
    """
    Publish a message to the SNS topic.

    Args:
        subject (str): Email subject line
        message (str): Email message body
    """
    if not SNS_TOPIC_ARN:
        logger.error("SNS_TOPIC_ARN environment variable not set.")
        return False

    try:
        response = sns_client.publish(
            TopicArn=SNS_TOPIC_ARN,
            Subject=subject,
            Message=message
        )
        logger.info(f"Message published to SNS. MessageId: {response['MessageId']}")
        return True
    except ClientError as e:
        logger.error(f"Failed to publish to SNS: {e}")
        return False


def format_vulnerability_details(finding_severity_counts, repository_name, image_digest):
    """
    Format vulnerability details for email notification.

    Args:
        finding_severity_counts (dict): Dictionary of severity counts
        repository_name (str): ECR repository name
        image_digest (str): Image digest hash

    Returns:
        str: Formatted message with vulnerability details
    """
    total_vulns = sum(finding_severity_counts.values())
    
    message_lines = [
        "=" * 70,
        "ECR VULNERABILITY SCAN ALERT",
        "=" * 70,
        "",
        f"Repository: {repository_name}",
        f"Image Digest: {image_digest}",
        "",
        f"Total Vulnerabilities Found: {total_vulns}",
        "",
        "SEVERITY BREAKDOWN:",
        "-" * 70,
    ]

    # Add severity counts in priority order
    for severity in ['CRITICAL', 'HIGH', 'MEDIUM', 'LOW', 'INFORMATIONAL', 'UNDEFINED']:
        count = finding_severity_counts.get(severity, 0)
        if count > 0:
            # Add visual indicator for critical/high
            indicator = "⚠️ " if severity in ['CRITICAL', 'HIGH'] else "  "
            message_lines.append(f"{indicator}{severity:15} : {count}")
    
    message_lines.extend([
        "",
        "-" * 70,
        "",
        "RECOMMENDED ACTIONS:",
        "1. Review vulnerabilities in the AWS ECR Console",
        "2. Update base images and dependencies to patched versions",
        "3. Do not deploy this image to production",
        "",
        f"View details: https://console.aws.amazon.com/ecr/repositories/private/{repository_name}",
        "",
        "=" * 70,
    ])

    return "\n".join(message_lines)


def format_clean_scan_message(repository_name, image_digest):
    """
    Format a clean scan message for email notification.

    Args:
        repository_name (str): ECR repository name
        image_digest (str): Image digest hash

    Returns:
        str: Formatted message for clean scan
    """
    message_lines = [
        "=" * 70,
        "ECR SCAN - NO VULNERABILITIES DETECTED ✓",
        "=" * 70,
        "",
        f"Repository: {repository_name}",
        f"Image Digest: {image_digest}",
        "",
        "Status: PASSED",
        "Vulnerabilities: 0",
        "",
        "This image has passed vulnerability scanning and is safe to deploy.",
        "",
        "=" * 70,
    ]

    return "\n".join(message_lines)


def format_failed_scan_message(repository_name, image_digest, failure_reason):
    """
    Format a failed scan message for email notification.

    Args:
        repository_name (str): ECR repository name
        image_digest (str): Image digest hash
        failure_reason (str): Reason for scan failure

    Returns:
        str: Formatted message for failed scan
    """
    message_lines = [
        "=" * 70,
        "ECR SCAN FAILED ✗",
        "=" * 70,
        "",
        f"Repository: {repository_name}",
        f"Image Digest: {image_digest}",
        "",
        f"Failure Reason: {failure_reason}",
        "",
        "POSSIBLE CAUSES:",
        "- Image OS is not supported by ECR Basic Scanning",
        "- Image architecture is not linux/amd64",
        "- Image manifest is corrupted or invalid",
        "- Temporary service issue",
        "",
        "RECOMMENDED ACTIONS:",
        "1. Verify the image was built for linux/amd64 architecture",
        "2. Check that the base OS is supported (Ubuntu, Debian, Amazon Linux, etc.)",
        "3. Review ECR scanning documentation for supported OS list",
        "4. Re-push the image and retry scanning",
        "",
        f"View repository: https://console.aws.amazon.com/ecr/repositories/private/{repository_name}",
        "",
        "=" * 70,
    ]

    return "\n".join(message_lines)


def lambda_handler(event, context):
    """
    AWS Lambda function to process ECR basic scan results and send SNS notifications.

    Args:
        event (dict): The EventBridge event payload containing the ECR scan result.
        context (object): Lambda context object.
    """
    logger.info("Received ECR scan event.")
    logger.debug(f"Event payload: {json.dumps(event)}")

    # Extract the detail from the EventBridge event
    try:
        detail = event.get('detail', {})
        scan_status = detail.get('scan-status')
        repository_name = detail.get('repository-name')
        image_digest = detail.get('image-digest')
        finding_severity_counts = detail.get('finding-severity-counts', {})

        if not scan_status:
            logger.error("Scan status not found in event detail.")
            return {
                'statusCode': 400,
                'body': json.dumps('Error: Scan status missing.')
            }

        if scan_status == "COMPLETE":
            if finding_severity_counts:
                # Bad image with vulnerabilities
                total_vulns = sum(finding_severity_counts.values())
                vuln_summary = []
                for severity in ['CRITICAL', 'HIGH', 'MEDIUM', 'LOW', 'INFORMATIONAL', 'UNDEFINED']:
                    count = finding_severity_counts.get(severity, 0)
                    if count > 0:
                        vuln_summary.append(f"{count} {severity}")
                
                log_message = (
                    f"Bad ECR Scan for repository '{repository_name}' (Image: {image_digest}). "
                    f"{total_vulns} vulnerabilities detected: {', '.join(vuln_summary)}."
                )
                logger.warning(log_message)

                # Send detailed SNS notification
                email_subject = f"⚠️ ECR Vulnerabilities Detected: {repository_name} ({total_vulns} issues)"
                email_message = format_vulnerability_details(
                    finding_severity_counts,
                    repository_name,
                    image_digest
                )
                publish_to_sns(email_subject, email_message)

            else:
                # Good image / no vulns
                log_message = (
                    f"Good ECR Scan for repository '{repository_name}' (Image: {image_digest}). "
                    f"No vulnerabilities detected."
                )
                logger.info(log_message)

                # Send clean scan SNS notification
                email_subject = f"✓ ECR Scan Passed: {repository_name}"
                email_message = format_clean_scan_message(repository_name, image_digest)
                publish_to_sns(email_subject, email_message)

        elif scan_status == "FAILED":
            failure_reason = detail.get('failure-reason', 'No specific reason provided.')
            log_message = (
                f"ECR Scan FAILED for repository '{repository_name}' (Image: {image_digest}). "
                f"Reason: {failure_reason}."
            )
            logger.error(log_message)

            # Send failed scan SNS notification
            email_subject = f"✗ ECR Scan Failed: {repository_name}"
            email_message = format_failed_scan_message(
                repository_name,
                image_digest,
                failure_reason
            )
            publish_to_sns(email_subject, email_message)

        else:
            # Handle other potential scan statuses
            log_message = (
                f"ECR Scan in unexpected status '{scan_status}' for repository '{repository_name}' "
                f"(Image: {image_digest})."
            )
            logger.info(log_message)

            # Send notification for unexpected status
            email_subject = f"ECR Scan Unexpected Status: {repository_name}"
            email_message = (
                f"Repository: {repository_name}\n"
                f"Image Digest: {image_digest}\n"
                f"Status: {scan_status}\n\n"
                f"Please investigate this unexpected scan status."
            )
            publish_to_sns(email_subject, email_message)

        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Event processed successfully',
                'repository': repository_name,
                'scan_status': scan_status
            })
        }

    except KeyError as e:
        error_message = f"Missing expected key in event payload: {e}"
        logger.error(error_message)
        
        # Send error notification
        email_subject = "❌ ECR Lambda Processing Error"
        email_message = f"Error: {error_message}\n\nEvent: {json.dumps(event, indent=2)}"
        publish_to_sns(email_subject, email_message)
        
        return {
            'statusCode': 400,
            'body': json.dumps(error_message)
        }

    except Exception as e:
        error_message = f"An unexpected error occurred: {e}"
        logger.error(error_message, exc_info=True)
        
        # Send error notification
        email_subject = "❌ ECR Lambda Unexpected Error"
        email_message = f"Error: {error_message}\n\nEvent: {json.dumps(event, indent=2)}"
        publish_to_sns(email_subject, email_message)
        
        return {
            'statusCode': 500,
            'body': json.dumps(error_message)
        }
