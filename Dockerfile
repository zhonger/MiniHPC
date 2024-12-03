FROM zhonger/minihpc-base:latest

LABEL maintainer="zhonger zhonger@live.cn"

# Update softwares
RUN apt-get update \
    && apt-get upgrade -y

# For LDAP Account
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libnss-ldapd libpam-ldapd ldap-utils
COPY conf/common-auth /etc/pam.d/common-auth
COPY conf/common-passwd /etc/pam.d/common-passwd
COPY conf/common-session /etc/pam.d/common-session
COPY conf/nsswitch.conf /etc/nsswitch.conf
COPY conf/ldap.conf /etc/ldap/ldap.conf
# COPY conf/nslcd.conf /etc/nslcd.conf
RUN rm /etc/update-motd.d/*
COPY conf/80-minihpc-news /etc/update-motd.d/80-minihpc-news
RUN chmod 644 /etc/pam.d/common-* /etc/ldap/ldap.conf /etc/nsswitch.conf \
    && chmod 640 /etc/nslcd.conf

# For openssh server
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server
COPY conf/sshd_config /etc/ssh/sshd_config
ADD scripts/getPublicKey /usr/sbin/getPublicKey
RUN chmod 700 /usr/sbin/getPublicKey \
    && chmod 644 /etc/ssh/sshd_config

# Install Figlet
RUN apt-get install -y figlet

# Install slurm-sbank tools
RUN apt-get install bc \
    && cd /tmp \
    && git clone https://github.com/zhonger/slurm-bank.git \
    && cd slurm-bank \
    && make install

# Clean apt-cache
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]