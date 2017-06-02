FROM postgres:9.6.2
MAINTAINER me@oreki.moe

RUN apt-get update && apt-get install -y cron python-pip python-dev build-essential libssl-dev libffi-dev
RUN pip install --upgrade cffi
RUN pip install --upgrade pyOpenSSL
RUN pip install qsctl
ADD backups-cron /etc/cron.d/backups-cron
RUN chmod 0644 /etc/cron.d/backups-cron
RUN touch /var/log/cron.log
ADD backups.sh /backups.sh
ADD start.sh /start.sh
RUN mkdir /root/.qingstor

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

CMD ["/start.sh"]
