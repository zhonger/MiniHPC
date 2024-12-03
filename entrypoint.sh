#!/bin/bash

# Prepare the directories 
if [ $ADMIN ]; then
    if [ $ADMIN == "true" ]; then
        echo "*******************************"
        echo "*          Admin Node         *"
        echo "*******************************"
        DBD_LOG="/opt/logs/slurmdbd.log"
        if [ ! -f "$DBD_LOG" ]; then
            touch $DBD_LOG
            chown -R slurm:slurm $DBD_LOG
        fi
        ln -s $DBD_LOG /var/log/slurmdbd.log

        CTLD_LOG="/opt/logs/slurmctld.log"
        if [ ! -f "$CTLD_LOG" ]; then
            touch $CTLD_LOG
            chown -R slurm:slurm $CTLD_LOG
        fi
        ln -s $CTLD_LOG /var/log/slurmctld.log    
    else
        echo "*******************************"
        echo "*          Work Node          *"
        echo "*******************************"
    fi
else
    echo "*******************************"
    echo "*          Work Node          *"
    echo "*******************************"
fi

MAIL_SPOOL="/opt/logs/slurm-spool/"
if [ ! -d $MAIL_SPOOL ]; then
    mkdir -p $MAIL_SPOOL
    chown -R slurm:slurm $MAIL_SPOOL
fi
MAIL_LOG="/opt/logs/slurm-mail/"
if [ -d  $MAIL_LOG ]; then
    rm -rf /var/spool/slurm-mail
fi
ln -s $MAIL_LOG /var/spool/slurm-mail

service munge start

if [ $LDAP_ENABLE ];then
    if [ $LDAP_ENABLE == "true" ];then
        chmod 600 /etc/nslcd.conf
        service nscd start
        service nslcd start
    fi
fi

if [ $SSH_ENABLE ];then
    if [ $SSH_ENABLE ];then
        service ssh start
    fi
fi

if [ $WORKNODE ];then
    if [ $WORKNODE == "true" ];then
        service slurmd start
    fi
fi

if [ $ADMIN ];then
    if [ $ADMIN == "true" ];then
        service cron start
        sleep 10
        service slurmdbd start
        sleep 10
        service slurmctld start
    fi
fi
service slurmd status
service slurmdbd status
service slurmctld status

echo ""
figlet MiniHPC
echo ""
echo " * Welcome to MiniHPC (Your own mini high performance cluster)"
echo " * For more details, please refer to https://github.com/zhonger/MiniHPC."
echo ""

/bin/bash