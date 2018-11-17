#!/usr/bin/env bash
if [[ ! -f "$1" ]]; then
    echo "File not found"
    exit 0;
fi

userName=`ls -l "$1" | awk -F" " '{print $3}'`

if [[ -r "$1" ]]
then
        echo $userName
fi

lsout=`ls -l "$1"`
groupw=${lsout:5:1}
if [[ $groupw = "w" ]]; then
    groupId=`ls -ln "$1" | awk -F" " '{print $4}'`;
fi

passwds=(`getent passwd`)
OLDIFS=$IFS
IFS=","
groups=(`getent group $groupId | awk -F":" '{print $4}'`)
IFS=$OLDIFS
for passwd in "${passwds[@]}"
do
    passwdName=`echo $passwd | awk -F":" '{print $1}'`
    passwdGId=`echo $passwd | awk -F":" '{print $4}'`;
    if [[ $passwdGId = $groupId ]]; then
        echo $passwdName
    else
      for group in "${groups[@]}"
        do
            if [[ $group = $passwdName && $group != $userName ]]; then
                echo $group
            fi
        done
    fi
done