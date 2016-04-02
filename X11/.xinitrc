numlockx on
redshift &
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
xbindkeys
setxkbmap -option "ctrl:nocaps"
dropbox &
udiskie --tray &
pulseaudio --start
mpd
workrave &
xss-lock -- i3lock -n &
exec awesome
