FROM ubuntu:bionic

# Install MoCOCrW dependencies
RUN apt update && apt -y install build-essential cmake pkg-config libboost-dev googletest git

# Install OpenSSL1.1.1
RUN git clone https://github.com/openssl/openssl.git
RUN cd openssl && git checkout OpenSSL_1_1_1-stable \ 
               && ./config -Wl,--enable-new-dtags,-rpath,'$(LIBRPATH)' \
               && make \
               && make install
RUN rm -rf openssl               

# Build as user so that tests cannot modify files in /root (running tests as
# root makes one of them fail)
RUN useradd user && mkdir /home/user && chown user:user /home/user
COPY files/fix-permissions.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD "bash"

# Provide mountpoints for bind-mounts
VOLUME ["/src", "/build"]
