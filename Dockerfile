FROM alpine:latest

# ssh-keygen -A generates all necessary host keys (rsa, dsa, ecdsa, ed25519) at default location.
RUN    apk update \
    && apk add openssh \
    && mkdir /root/.ssh \
    && chmod 0700 /root/.ssh \
    && ssh-keygen -A \
    && adduser -D -s /bin/false tunuser \
    && passwd -u tunuser \
    && mkdir /home/tunuser/.ssh \
    && chmod 0700 /home/tunuser/.ssh \
    && touch /home/tunuser/.ssh/authorized_keys \
    && chmod 0600 /home/tunuser/.ssh/authorized_keys \
    && chown -R tunuser:tunuser /home/tunuser \
    && sed -i s/^#PasswordAuthentication\ yes/PasswordAuthentication\ no/ /etc/ssh/sshd_config \
    && sed -i s/^#AllowAgentForwarding\ yes/AllowAgentForwarding\ no/ /etc/ssh/sshd_config

# This image expects AUTHORIZED_KEYS environment variable to contain your ssh public key.

COPY docker-entrypoint.sh /
COPY tunuser-sshd.conf /tmp/
RUN cat /tmp/tunuser-sshd.conf >> /etc/ssh/sshd_config

EXPOSE 22 2022

ENTRYPOINT ["/docker-entrypoint.sh"]

# -D in CMD below prevents sshd from becoming a daemon. -e is to log everything to stderr.
CMD ["/usr/sbin/sshd", "-D", "-e"]


