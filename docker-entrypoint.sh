#!/bin/bash
if [ $WEBROOT != "" ]
then

  mkdir -p $WEBROOT
  chown -R www-data: $WEBROOT

else
  echo "Web Root is in /app"
fi

### If the container was started with the env IS_CRON=1 make it only run the cron daemon
if [ 1 -eq ${IS_CRON:-0} ]
then

  crontab -u www-data crontab.file
  /usr/sbin/cron -f

elif [ 1 -eq ${IS_SUPERVISOR:-0} ]
then

  /usr/bin/supervisord --nodaemon -c /etc/supervisor/supervisord.conf

else
  /usr/sbin/php-fpm8.1 -F
fi
