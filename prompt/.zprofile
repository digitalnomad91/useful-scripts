eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

cat /etc/motd
neofetch
for f in /etc/update-motd.d/*; do
  bash "$f"
done
