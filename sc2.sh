#!/usr/bin/env bash
if [[ ! -f "$1" ]]; then
    echo "File not found"
    exit 0;
fi

userName=`ls -l "$1" | awk -F" " '{print $3}'`
users=("${userName}")

if [[ -w "$1" ]]
then
        echo ${userName}
fi

groupId=`ls -ln "$1" | awk -F" " '{print $4}'`;
OLDIFS=$IFS
IFS=","
groups=(`getent group ${groupId} | awk -F":" '{print $4}'`)
for group in "${groups[@]}"
do
    users=("${users[@]}" "${group}")
done
IFS=$'\n'
passwds=(`getent passwd`)
IFS=${OLDIFS}

lsout=`ls -l "$1"`
groupW=${lsout:5:1}
if [[ ${groupW} = "w" ]]; then
    for passwd in "${passwds[@]}"
    do
        passwdName=`echo ${passwd} | awk -F":" '{print $1}'`
        passwdGId=`echo ${passwd} | awk -F":" '{print $4}'`
        if [[ ${passwdGId} = ${groupId} && ${passwdName} != ${userName} ]]; then
            echo ${passwdName}
        else
          for group in "${groups[@]}"
            do
                if [[ ${group} = ${passwdName} && ${group} != ${userName} ]]; then
                    echo ${group}
                fi
            done
        fi
    done
fi

otherW=${lsout:8:1}
if [[ ${otherW} = "w" ]]; then
    for passwd in "${passwds[@]}"
    do
        passwdName=`echo ${passwd} | awk -F":" '{print $1}'`
        contains="false"
        for user in "${users[@]}"
        do
            echo $user
            echo $passwdName
            if [[ ${user} = ${passwdName} ]]; then
                contains="true"
                echo "true"
            fi
        done
        if [[ ${contains} = "false" ]] ; then
            echo ${passwdName}
        fi
    done
fi
