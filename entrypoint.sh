#!/bin/bash

: ${SFTP_DIR:?} ${SFTP_USER:?} ${SFTP_UID:?}
: ${SFTP_PASS:=`pwgen -scnB1 12`}
if [ ! -e "$SFTP_DIR" ]; then
    >&2 echo "${SFTP_DIR} doesn't exist! Did you forget to mount a volume?"
    exit 1
fi

sed -i 's/\(Subsystem\s\+sftp\).*/\1 internal-sftp/g' /etc/ssh/sshd_config

cat <<EOF >> /etc/ssh/sshd_config
AllowTCPForwarding no
ClientAliveInterval 300
ForceCommand internal-sftp
EOF

groupadd -o -g $SFTP_UID $SFTP_USER
useradd -MNo -d $SFTP_DIR -u $SFTP_UID -g $SFTP_UID -s /usr/sbin/nologin $SFTP_USER
echo "${SFTP_USER}:${SFTP_PASS}" | chpasswd

exec "$@"
