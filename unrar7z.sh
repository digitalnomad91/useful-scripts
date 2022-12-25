#!/bin/bash
#Skapat av Gymmarn 2010-02-11
#Variabel $1 is the folder sent
#Start to check if we're in the right folder (rTorrent seems to bug sometimes)

FOLDER="${@}"
echo "---------------------------------------------------------------------------"
echo "$FOLDER"
echo "$(ls -d "$FOLDER" | grep -F /storage/rtorrent-downloads/)"

chmod -R 0777 /storage/rtorrent-downloads /storage/rtorrent-downloads-tv

if [ "$(ls -d "$FOLDER" | grep -F /storage/rtorrent-downloads/)" ] || [ "$(ls -d "$FOLDER" | grep -F /storage/rtorrent-downloads-tv/)" ]; then
        yes no | nice -n 15 touch /home/rtorrent/pidfile
        for directory in [find "$FOLDER" -type d]; do
            if [ $(ls "$directory" | fgrep -i .rar) ]; then
                rarFile=$(ls "$directory" | fgrep -i .rar)
                searchPath="$directory/$rarFile"
                yes no | nice -n 15 /usr/bin/7z x -y "$searchPath" -o"$directory"
            #Check for .001 files and unpack them if found
            elif [ $(ls "$directory" | fgrep -i .001) ]; then
                rarFile=$(ls "$directory" | fgrep -i .001)
                searchPath="$directory/$rarFile"
                yes no | nice -n 15 /usr/bin/7z x -y "$searchPath" -o"$directory"
            #Check for .zip files and unpack them if found
            elif [ $(ls "$directory" | fgrep -i .zip) ]; then
                for zipFiles in $(ls "$directory" | fgrep -i .zip); do
                    searchPath="$directory/$zipFiles"
                    yes no | nice -n 15 /usr/bin/7z x -y "$searchPath" -o"$directory"
                done
                #When there is .zip files there is often .rar/.001 in them. Check and unpack if so
                if [ $(ls "$directory" | fgrep -i .rar) ]; then
                    rarFile=$(ls "$directory" | fgrep -i .rar)
                    searchPath="$directory/$rarFile"
                    yes no | nice -n 15 /usr/bin/7z x -y "$searchPath" -o"$directory"
                #Check for .001 files and unpack them if found
                elif [ $(ls "$directory" | fgrep -i .001) ]; then
                    rarFile=$(ls "$directory" | fgrep -i .001)
                    searchPath="$directory/$rarFile"
                    yes no | nice -n 15 /usr/bin/7z x -y "$searchPath" -o"$directory"
                fi
            fi
        done
        yes no | $(nice -n 15 chmod -R 0777 "$FOLDER")
        yes no | $(nice -n 15 rm -f /home/rtorrent/pidfile)
fi

echo "------------------------------END UNRAR SCRIPT---------------------------------------------"
