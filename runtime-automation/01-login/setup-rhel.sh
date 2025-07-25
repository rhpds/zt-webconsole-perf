#!/bin/sh
echo "Starting module called 01-login" >> /tmp/progress.log

systemctl enable pmlogger.service

systemctl start pmlogger.service
