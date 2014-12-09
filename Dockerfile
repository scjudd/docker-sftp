FROM ubuntu:trusty
MAINTAINER Spencer Judd <spencercjudd@gmail.com>

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openssh-sftp-server \
    pwgen \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /var/run/sshd

VOLUME ["/etc/ssh"]
EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D", "-e"]

COPY entrypoint.sh /
