#!/bin/bash
set -e

echo "[Info] Starting Hass.io folder rsync docker container!"

CONFIG_PATH=/data/options.json
rsyncserver=$(jq --raw-output ".rsyncserver" $CONFIG_PATH)
rootfolder=$(jq --raw-output ".rootfolder" $CONFIG_PATH)
username=$(jq --raw-output ".username" $CONFIG_PATH)
password=$(jq --raw-output ".password" $CONFIG_PATH)

syncconfig=$(jq --raw-output ".syncconfig" $CONFIG_PATH)
syncaddons=$(jq --raw-output ".syncaddons" $CONFIG_PATH)
syncbackup=$(jq --raw-output ".syncbackup" $CONFIG_PATH)
syncshare=$(jq --raw-output ".syncshare" $CONFIG_PATH)
syncssl=$(jq --raw-output ".syncssl" $CONFIG_PATH)
syncmedia=$(jq --raw-output ".syncmedia" $CONFIG_PATH)

rsyncurl="$username@$rsyncserver::$rootfolder"

echo "[Info] trying to rsync hassio folders to $rsyncurl"
echo ""

echo "syncconfig: $syncconfig"
echo "syncaddons: $syncaddons"
echo "syncbackup: $syncbackup"
echo "syncshare: $syncshare"
echo "syncssl: $syncssl"
echo "syncmedia: $syncmedia"


if [ "$syncconfig" == "true" ]
then
	echo "[Info] sync /config"
	echo ""
	sshpass -p $password rsync --no-perms -rltvh --delete --exclude '*.db-shm' --exclude '*.db-wal' /config/ $rsyncurl/config/ 
fi

if [ "$syncaddons" == "true" ]
then
	echo "[Info] sync /addons"
	echo ""
	sshpass -p $password rsync --no-perms -rltvh --delete /addons/ $rsyncurl/addons/ 
fi

if [ "$syncbackup" == "true" ]
then
	echo "[Info] sync /backup"
	echo ""
	sshpass -p $password rsync --no-perms -rltvh --delete /backup/ $rsyncurl/backup/ 
fi

if [ "$syncshare" == "true" ]
then
	echo "[Info] sync /share"
	echo ""
	sshpass -p $password rsync --no-perms -rltvh --delete /share/ $rsyncurl/share/ 
fi

if [ "$syncssl" == "true" ]
then
	echo "[Info] sync /ssl"
	echo ""
	sshpass -p $password rsync --no-perms -rltvh --delete /ssl/ $rsyncurl/ssl/ 
fi

if [ "$syncmedia" == "true" ]
then
	if [ -d "/media" ]; then
	 echo ""
	 echo "[Info] sync /media"
	 sshpass -p $password rsync --no-perms -rltvh --delete /media/ $rsyncurl/media/
	else 
	 echo ""
	 echo "[Info] /media not existing"
	fi
fi

echo "[Info] Finished rsync"