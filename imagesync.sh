#!/bin/bash

#get username and password
USER=angel_img                   #Your username
PASS=86Izkl7$                   #Your password
HOST="laltex-extranet.co.uk"          #Keep just the address
LCD="/storage/USERS/Mary/Images/"     #Your local directory
RCD="/"               #FTP server directory
LOG="/var/log/lftp.log"	#LOG record

telegram-send -g "$(hostname) Image Sync underway"
lftp -f "
open $HOST
user $USER $PASS
set ftp:passive-mode true
set ftp:prefer-epsv false
set ftp:use-allo false
lcd $LCD
mirror --log=$LOG -vvv --exclude _gsdata_/ --no-perms --only-newer --delete --parallel=10 $RCD $LCD
bye
" >> $LOG 2>> $LOG
chmod 664 $LOG
chmod -R 0777 $LCD

size=$(wc -c < "$LOG")
telegram-send -g "$(hostname) Image Sync complete"

if [ $size -gt 0 ]; then
	telegram-send -g "$(hostname)" -f $LOG
else
	telegram-send -g "$(hostname) Image Sync - No files have changed"
fi
