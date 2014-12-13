FROM ubuntu:trusty
MAINTAINER Spencer Judd <spencercjudd@gmail.com>

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openssh-sftp-server \
    pwgen \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /var/run/sshd

RUN sed -i 's/\(Subsystem\s\+sftp\).*/\1 internal-sftp/g' /etc/ssh/sshd_config \
 && echo "AllowTCPForwarding no"      >> /etc/ssh/sshd_config \
 && echo "ClientAliveInterval 300"    >> /etc/ssh/sshd_config \
 && echo "ForceCommand internal-sftp" >> /etc/ssh/sshd_config

VOLUME ["/etc/ssh"]
EXPOSE 22

CMD /run.sh
COPY run.sh /
