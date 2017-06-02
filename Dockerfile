FROM postgres:9.6.2
MAINTAINER me@oreki.moe

RUN apt-get update && apt-get install -y cron
ADD backups-cron /etc/cron.d/backups-cron
RUN chmod 0644 /etc/cron.d/backups-cron
RUN touch /var/log/cron.log
ADD backups.sh /backups.sh
ADD start.sh /start.sh

CMD ["/start.sh"]
