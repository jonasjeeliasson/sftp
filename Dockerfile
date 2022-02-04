FROM debian:bullseye
MAINTAINER Adrian Dvergsdal [atmoz.net]

# Steps done in one RUN layer:
# - Install packages
# - OpenSSH needs /var/run/sshd to run
# - Remove generic host keys, entrypoint generates unique keys
RUN apt-get update && \
    apt-get -y install openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd && \
    rm -f /etc/ssh/ssh_host_*key*

COPY files/sshd_config /etc/ssh/sshd_config
COPY files/ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key
COPY files/ssh_host_ed25519_key.pub /etc/ssh/ssh_host_ed25519_key.pub
COPY files/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
COPY files/ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa_key.pub
COPY files/host-keys/ /etc/ssh/
COPY files/create-sftp-user /usr/local/bin/
COPY files/entrypoint /

EXPOSE 22

ENTRYPOINT ["/entrypoint"]
