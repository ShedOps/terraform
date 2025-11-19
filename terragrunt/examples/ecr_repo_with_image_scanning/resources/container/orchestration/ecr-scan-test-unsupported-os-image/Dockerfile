# Use an unsupported Version of Alpine Linux
# See: https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-scanning-basic.html
FROM alpine:3.16

# Add a label to identify this as a test image
LABEL purpose="ecr-scan-test-good"
LABEL description="Unsupported Alpine image for testing ECR scanning"

# Install minimal packages to make it a valid container
RUN apk add --no-cache \
    ca-certificates \
    && rm -rf /var/cache/apk/*

# Create a simple app
RUN echo '#!/bin/sh' > /app.sh && \
    echo 'echo "Clean test image - should fail scan due to being an unsupported image"' >> /app.sh && \
    echo 'sleep infinity' >> /app.sh && \
    chmod +x /app.sh

CMD ["/app.sh"]
