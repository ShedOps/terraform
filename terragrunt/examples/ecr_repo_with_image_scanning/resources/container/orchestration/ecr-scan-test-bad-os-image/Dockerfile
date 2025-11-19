# OS version directly from your support matrix:
# Ubuntu (Bionic) 18.04 (ESM) – scanned by AWS native basic + Clair basic
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# Install a bunch of common OS-level packages, but DO NOT do a full dist-upgrade.
# This tends to leave a lot of vulnerable libs around over time.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        openssl \
        openssh-client \
        gnupg2 \
        tzdata \
        build-essential \
        apt-transport-https \
        net-tools \
        iputils-ping \
        dnsutils && \
    rm -rf /var/lib/apt/lists/*

# Dummy command – the container doesn’t actually need to do anything
CMD ["sleep", "infinity"]
