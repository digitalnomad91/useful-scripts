#!/bin/bash
#Variabel $1 is the folder sent
# used with rtorrent to automatically unrar torrents on completion (for jellyfin / sonarr / radarr automation)
# add to .rtorrent.rc: method.set_key = event.download.finished,unpack_rar,"execute=~/unrar_files.sh,$d.base_path="
# see .rtorrent.rc in this repo for other custom rtorrent configurations
#Start to check if we're in the right folder (rTorrent seems to bug sometimes)
echo "ls -d $1 | grep -F /disk2/rtorrent/download/)";
if [ "$(ls -d $1 | grep -F /disk2/rtorrent/download/)" ] || [ "$(ls -d $1 | grep -F /disk1/rtorrent/download/)" ]; then
        #Create only 1 instance of this script to avoid rTorrent crashing
        if [ ! "$(ls /home/rtorrent/ | fgrep -i pidfile)" ]; then
                yes no | nice -n 15 touch /home/rtorrent/pidfile
                #Find and repeat for all folders and subfolders
                for directory in $(find $1 -type d); do
                        #Check for .rar files and unpack them if found
                        if [ "$(ls $directory | fgrep -i .rar)" ]; then
                                rarFile=`ls $directory | fgrep -i .rar`;
                                searchPath="$directory/$rarFile"
                                yes no | nice -n 15 unrar x -o+ $searchPath $directory
                        #Check for .001 files and unpack them if found
                        elif [ "$(ls $directory | fgrep -i .001)" ]; then
                                rarFile=`ls $directory | fgrep -i .001`;
                                searchPath="$directory/$rarFile"
                                yes no | nice -n 15 unrar x -o+ $searchPath $directory
                        #Check for .zip files and unpack them if found
                        elif [ "$(ls $directory | fgrep -i .zip)" ]; then
                                for zipFiles in `ls $directory | fgrep -i .zip`; do
                                        searchPath="$directory/$zipFiles"
                                        yes no | nice -n 15 unzip -n $searchPath -d $directory
                                done
                                #When there is .zip files there is often .rar/.001 in them. Check and unpack if so
                                if [ "$(ls $directory | fgrep -i .rar)" ]; then
                                rarFile=`ls $directory | fgrep -i .rar`;
                                searchPath="$directory/$rarFile"
                                yes no | nice -n 15 unrar x -o+ $searchPath $directory
                                #Check for .001 files and unpack them if found
                                elif [ "$(ls $directory | fgrep -i .001)" ]; then
                                rarFile=`ls $directory | fgrep -i .001`;
                                searchPath="$directory/$rarFile"
                                yes no | nice -n 15 unrar x -o+ $searchPath $directory
                                fi
                        fi
			chmod -R 0777 $directory
                done
                yes no | nice -n 15 rm -f /home/rtorrent/pidfile
        fi
fi
