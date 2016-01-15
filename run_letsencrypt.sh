#!/bin/bash

# install letsencrypt if not in persistentvolume
if [ ! -f /var/ssl/config.sh ]; then
  cp -vfpr /tmp/ssl/* /var/ssl/
fi

cd /var/ssl
/root/letsencrypt.sh/letsencrypt.sh -c

sleep 3600

# access log rotation
file=/var/ssl/access.log
minimumsize=100
actualsize=$(wc -c <"$file")
if [ $actualsize -ge $minimumsize ]; then
    echo "rotate nginx access.log";
    rm -f /var/ssl/access.log
    kill -USR1 `cat /var/run/nginx.pid`
fi

# error log rotation
file=/var/ssl/error.log
minimumsize=100
actualsize=$(wc -c <"$file")
if [ $actualsize -ge $minimumsize ]; then
    echo "rotate nginx error.log";
    rm -f /var/ssl/error.log
    kill -USR1 `cat /var/run/nginx.pid`
fi