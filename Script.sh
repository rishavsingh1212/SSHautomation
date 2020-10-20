#!/bin/bash

filename="id_rsa"
path="$HOME/.ssh"

declare -a array_ips
echo "How many hosts you want to connect with?"
read ips
echo "enter $ips ips (click enter after every ip): "
for(( c = 0 ; c < $ips ; c++))
do
  read ip_num
#  while read abc_elements
#  do
  array_ips[$c]="$ip_num"
#  done
done
echo -e "Your IPS are :${array_ips[@]}"

for a in ${array_ips[@]}
do
    echo "Making connection to $a"
    echo "************************************Rishav Script*********************************"
    HOST="$a"
    if [ -f $path/$filename ]
    then
        echo "RSA key exists on $path/$filename, using existing file"
    else
        ssh-keygen -t rsa -f "$path/$filename"
        echo RSA key pair generated
    fi
    echo "We need to log into $HOST as test to set up your public key (hopefully last time you'll use password from this computer)"
    cat "$path/$filename.pub" | ssh "$HOST" -l "test" '[ -d .ssh ] || mkdir .ssh; cat >> .ssh/authorized_keys; chmod 700 ~/.ssh; chmod 600 ~/.ssh/authorized_keys'
    status=$?
    if [ $status -eq 0 ]
    then
        echo "Set up complete, try to ssh to $host now"
    else
        echo "an error has occurred"
        exit 255
    fi
done
