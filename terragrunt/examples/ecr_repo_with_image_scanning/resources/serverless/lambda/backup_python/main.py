# lambda/main.py
import json
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    """
    AWS Lambda function to process ECR basic scan results.

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
                
                print_message = (
                    f"Bad ECR Scan for repository '{repository_name}' (Image: {image_digest}). "
                    f"{total_vulns} vulnerabilities detected: {', '.join(vuln_summary)}."
                )
                logger.warning(print_message)
            else:
                # Good image / no vulns
                print_message = (
                    f"Good ECR Scan for repository '{repository_name}' (Image: {image_digest}). "
                    f"No vulnerabilities detected."
                )
                logger.info(print_message)
        elif scan_status == "FAILED":
            failure_reason = detail.get('failure-reason', 'No specific reason provided.')
            print_message = (
                f"ECR Scan FAILED for repository '{repository_name}' (Image: {image_digest}). "
                f"Reason: {failure_reason}."
            )
            logger.error(print_message)
        else:
            # Handle other potential scan statuses if needed, though 'COMPLETE' and 'FAILED' are most common for results
            print_message = (
                f"ECR Scan in unexpected status '{scan_status}' for repository '{repository_name}' "
                f"(Image: {image_digest})."
            )
            logger.info(print_message)

    except KeyError as e:
        logger.error(f"Missing expected key in event payload: {e}")
        print_message = f"Error processing event: Missing key {e}."
    except Exception as e:
        logger.error(f"An unexpected error occurred: {e}", exc_info=True)
        print_message = f"An unexpected error occurred: {e}."

    return {
        'statusCode': 200,
        'body': json.dumps(print_message) # Optionally return the message
    }
