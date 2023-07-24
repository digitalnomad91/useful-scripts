#!/bin/bash

## crontab one-liner to check if port is active & run a command to start dangler matrix/irc bot tcp server if it's not
if timeout 2 bash -c "</dev/tcp/subtlefu.ge/1337"; then echo "active"; else tmux send-keys -t dangler_bot_tcp:0 "cd /root/matrix-js-sdk-bot-template && node tcpserver.js" ENTER; fi

# alias for finding which process a particular port is running from
#alias ports='sudo lsof -i -P -n | grep LISTEN'
alias ports='netstat -tulpn | grep :'

#shortcut for searching for text in file contents
alias fineInFile='grep -liR' #e.g. findInFile "text" file

#update php & composer active CLI version
sudo update-alternatives --set php /usr/bin/php8.0
sudo update-alternatives --set phar /usr/bin/phar8.0
sudo update-alternatives --set phar.phar /usr/bin/phar.phar8.0
sudo update-alternatives --set phpize /usr/bin/phpize8.0
sudo update-alternatives --set php-config /usr/bin/php-config8.0

## register a wildcard domain name SSL certficiate with LetsEncrypt (valid for subtlefu.ge & *.subtlefu.ge):
certbot certonly --manual --preferred-challenges=dns --email dfoolz@protonmail.com --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d *.subtlefu.ge -d subtlefu.ge


## download / archive entire website using wget:

wget --recursive  --level 5  --no-clobber  --page-requisites --adjust-extension  --span-hosts  --convert-links --restrict-file-names=windows  --domains codebuilder.us --no-parent  https://codebuilder.us

  #The options are:
  #  --recursive: download the entire Web site.
  #  --domains website.org: don't follow links outside website.org.
  #  --no-parent: don't follow links outside the directory tutorials/html/.
  #  --page-requisites: get all the elements that compose the page (images, CSS and so on).
  #  --html-extension: save files with the .html extension.
  #  --convert-links: convert links so that they work locally, off-line.
  #  --restrict-file-names=windows: modify filenames so that they will work in Windows as well.
  #  --no-clobber: don't overwrite any existing files (used in case the download is interrupted and resumed).

#### clone every repo in an organization (must be logged into github with gh)
gh repo list dexcelerate --limit 1000 | while read -r repo _; do
  gh repo clone "$repo" "$repo"
done
