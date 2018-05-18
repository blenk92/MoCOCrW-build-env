FROM ubuntu:bionic

# Install MoCOCrW dependencies
RUN apt update && apt -y install build-essential cmake pkg-config libboost-dev libssl1.0-dev openssl1.0 googletest

# MoCOCrW tests depend on OpenSSL output, which changed from 1.0 to 1.1. Force
# use of 1.0 until the tests support both.
RUN ln -fs /usr/lib/ssl1.0/openssl /usr/bin/openssl

# Build as user so that tests cannot modify files in /root (running tests as
# root makes one of them fail)
RUN useradd user && mkdir /home/user && chown user:user /home/user
COPY files/fix-permissions.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD "bash"

# Provide mountpoints for bind-mounts
VOLUME ["/src", "/build"]
