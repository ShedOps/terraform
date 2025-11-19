# Use the latest Alpine Linux - NO vulnerabilities (at time of creation!)
FROM alpine:3.22

# Add a label to identify this as a test image
LABEL purpose="ecr-scan-test-good"
LABEL description="Clean Alpine image for testing ECR scanning"

# Install minimal packages to make it a valid container
RUN apk add --no-cache \
    ca-certificates \
    && rm -rf /var/cache/apk/*

# Create a simple app
RUN echo '#!/bin/sh' > /app.sh && \
    echo 'echo "Clean test image - should pass vulnerability scan"' >> /app.sh && \
    echo 'sleep infinity' >> /app.sh && \
    chmod +x /app.sh

CMD ["/app.sh"]
