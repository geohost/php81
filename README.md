# php81
Dockerfile for DockerHub: geohost/php81
Container based on Ubuntu 20.04 with php8.1-fpm or cron
If the container was started with the env IS_CRON=1 make it only run the cron daemon
or with env IS_SUPERVISOR=1 will start the supervisord.   

You can set the web root with the variable: WEBROOT
