#!/bin/bash

## crontab one-liner to check if port is active & run a command to start dangler matrix/irc bot tcp server if it's not
if timeout 2 bash -c "</dev/tcp/subtlefu.ge/1337"; then echo "active"; else tmux send-keys -t dangler_bot_tcp:0 "cd /root/matrix-js-sdk-bot-template && node tcpserver.js" ENTER; fi

