#!/bin/bash

#Script to add a new user and set the sshkey 
#Author: Vinicius Sá
#Date: 13/02/23

[ $# -eq 0 ] && { echo 'USAGE: username "ssh_key"'; exit 1; }

username=${1}
ssh_key=${2}
authorizedKey=/home/${1}/.ssh/authorized_keys
userdotssh=/home/${1}/.ssh/
homeuser=/home/${1}/
logfile=/var/log/adduser

[ -f "$logfile" ] || touch "$logfile" 
exec &> >(tee -a "$logfile")

echo "Checking if $username exist"
if [ -d "/home/$username" ]; then
    echo "$username exist, continuing" && chown $username: $homeuser && chmod 755 $homeuser && echo "right permissions set" || echo "fail" 
else
    echo " $username does not existe, creating..." && sudo useradd -m $username && echo "done, $username created" || echo "fail" 
fi

echo "Checking if ${userdotssh} exist"
if [ -d "$userdotssh" ]; then
    echo "$userdotssh exist, continuing "
else
    echo "$userdotssh does not exist, creating..." && mkdir $userdotssh && chown $username: $userdotssh  && chmod 700 $userdotssh && echo "done" || echo "fail"
fi

echo "Checking if authorized_keys exist" 
if [ -d "$authorizedKey" ]; then
    echo "Exist, adding keys to  $username authorized_keys" && echo $ssh_key >> $authorized_keys && echo "done" || echo "fail" 
else 
    echo " authorized_keys not created, creating and adding keys" && echo $ssh_key >> $authorizedKey && chmod 644 $authorizedKey && echo "done" || echo "fail" 
fi 
