numlockx on
redshift &
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
xbindkeys
setxkbmap -option "ctrl:nocaps"
dropbox &
udiskie --tray &
pulseaudio --start
mpd
exec awesome
