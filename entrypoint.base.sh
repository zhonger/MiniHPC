#!/bin/bash

# Prepare the directories 

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

MAIL_LOG="/opt/logs/slurm-mail/"
if [ ! -d "$MAIL_LOG" ]; then
    mkdir -p $MAIL_LOG
    touch $MAIL_LOG/slurm-send-mail.log
    touch $MAIL_LOG/slurm-spool-mail.log
    chown -R slurm:slurm $MAIL_LOG
fi
rm -rf /var/log/slurm-mail
ln -s $MAIL_LOG /var/log/slurm-mail

service munge start

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

/bin/bash