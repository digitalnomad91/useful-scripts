#!/bin/bash
## Stuff that needs to be run on startup


## OutlineWiki Start
tmux new-session -d -s outlinewiki 
tmux send-keys -t outlinewiki:0 "cd /root/outline && yarn start" ENTER

# Mount ext disks
mount /dev/sdb1 /disk1
mount /dev/sdc1 /disk2

# Start Synapse (Matrix Server)
tmux new-session -d -s matrix_synapse_server
tmux send-keys -t matrix_synapse_server:0 "source /opt/venvs/matrix-synapse/bin/activate && cd /etc/matrix-synapse/ && /opt/venvs/matrix-synapse/bin/python3 -m synapse.app.homeserver --config-path=/etc/matrix-synapse/homeserver.yaml --config-path=/etc/matrix-synapse/conf.d/" ENTER

# Start Sydent (Matrix Identity)
tmux new-session -d -s matrix_sydent 
tmux send-keys -t matrix_sydent:0 "source ~/.sydent/bin/activate && python -m sydent.sydent" ENTER

# Start IRC Bridge Bot
tmux new-session -d -s matrix_irc_bridge 
tmux send-keys -t matrix_irc_bridge:0 "cd /root/matrix-appservice-irc && node app.js -c config.yaml -f /etc/matrix-synapse/appservice-registration-irc.yaml -p 9995" ENTER

# Start Dangler Matrix Bot Core
tmux new-session -d -s dangler_bot
tmux send-keys -t dangler_bot:0 "cd /root/matrix-js-sdk-bot-template && node index.js" ENTER

# Start Dangler Matrix Bot TCP Listen Server (Message Echo)
#tmux new-session -d -s dangler_bot_tcp
#tmux send-keys -t dangler_bot_tcp:0 "cd /root/matrix-js-sdk-bot-template && node tcpserver.js" ENTER

# Start Hydrogen Matrix Web Client
tmux new-session -d -s hydrogen_matrix_client
tmux send-keys -t hydrogen_matrix_client:0 "cd /root/hydrogen-web && yarn start" ENTER

# Start matrix.subtlefu.ge (preview room share link - matrix.to)
tmux new-session -d -s matrix_share
tmux send-keys -t matrix_share:0 "cd /var/www/matrix.to && yarn start" ENTER

# Start Synapse Matrix Admin GUI
tmux new-session -d -s synapse_admin_client
tmux send-keys -t synapse_admin_client:0 "cd /root/synapse-admin && yarn start" ENTER

###### START ELEMENT-WEB CLIENT #####
#tmux new-session -d -s element_web_client
#tmux send-keys -t element_web_client:0 "cd /var/www/element-web && yarn start" ENTER

###### START INSPIRCD IRC DAEMON #####
tmux new-session -d -s inspircd
tmux send-keys -t inspircd:0 "inspircd --runasroot" ENTER

###### START ANOPE IRC SERVICES #####
tmux new-session -d -s anope
tmux send-keys -t anope:0 "su anope" ENTER
tmux send-keys -t anope:0 "cd /home/services && bin/services" ENTER

##### Start stackedit docs #####
tmux new-session -d -s stackedit
tmux send-keys -t stackedit:0 "cd /var/www/stackedit && npm start" ENTER

###### START RTORRENT #####
tmux new-session -d -s rtorrent
tmux send-keys -t rtorrent:0 "sudo -u rtorrent rtorrent" ENTER

###### START FLOOD TORRENT WEB GUI #####
tmux new-session -d -s flood
tmux send-keys -t flood:0 "cd /var/www/flood && flood --port 3005" ENTER

###### START OMBI #####
tmux new-session -d -s ombi_server
tmux send-keys -t ombi_server:0 "cd /opt/Ombi && sudo -u ombi /opt/Ombi/Ombi --storage /etc/Ombi/ --host http://*:5009" ENTER

###### START PIXELFED HORIZON #####
tmux new-session -d -s pixelfed_horizon
tmux send-keys -t pixelfed_horizon:0 "cd /var/www/pixelfed && php artisan horizon" ENTER

#################### START ALL ZNC SERVERS ####################
tmux new-session -d -s corruptnet_znc
tmux send-keys -t corruptnet_znc:0 "sudo -u corruptnet_znc znc" ENTER

tmux new-session -d -s freenode_znc
tmux send-keys -t freenode_znc:0 "sudo -u freenode_znc znc" ENTER

tmux new-session -d -s imperial_znc
tmux send-keys -t imperial_znc:0 "sudo -u imperial_znc znc" ENTER

tmux new-session -d -s ipt_znc
tmux send-keys -t ipt_znc:0 "sudo -u ipt_znc znc" ENTER

tmux new-session -d -s p2pirc_znc
tmux send-keys -t p2pirc_znc:0 "sudo -u p2pirc_znc znc" ENTER

tmux new-session -d -s subtlefuge_znc
tmux send-keys -t subtlefuge_znc:0 "sudo -u subtlefuge_znc znc" ENTER

tmux new-session -d -s tripsit_znc
tmux send-keys -t tripsit_znc:0 "sudo -u tripsit_znc znc" ENTER

tmux new-session -d -s tb_znc
tmux send-keys -t tb_znc:0 "sudo -u tb_znc znc" ENTER

tmux new-session -d -s znc_libera
tmux send-keys -t znc_libera:0 "sudo -u znc_libera znc" ENTER

tmux new-session -d -s oftc_znc
tmux send-keys -t oftc_znc:0 "sudo -u oftc_znc znc" ENTER

tmux new-session -d -s opentrackers_znc
tmux send-keys -t opentrackers_znc:0 "sudo -u opentrackers_znc znc" ENTER

#################### END ZNC ####################
