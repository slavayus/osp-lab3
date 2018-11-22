#!/usr/bin/env bash
if [[ -z "$1" ]]; then
    echo "Enter user name"
    exit 0;
fi

userId=`getent passwd $1 |  awk -F":" '{print $3}'`
groups=(`getent passwd $1 |  awk -F":" '{print $4}'`)
groups+=(`getent group | grep $1 | awk -F":" '{print $3}'`)

IFS=$'\n'
data=(`ls -ln`)
for file in "${data[@]}"
do
    if [[ ${file:0:1} != "-" ]]; then
        continue
    fi

    fileName=`echo ${file} | awk -F" " '{print $9}'`
    fileUserId=`echo ${file} | awk -F" " '{print $3}'`

    if [[ ${fileUserId} == ${userId} ]] && [[ ${file:1:1} == "r" ]]; then
        echo ${fileName}
        continue
    fi

    fileGroupId=`echo ${file} | awk -F" " '{print $4}'`

    if [[ ${file:4:1} == "r" ]]; then
          for group in "${groups[@]}" ; do
              if [[ ${group} ==  ${fileGroupId} ]]; then
                  echo ${fileName}
                  continue 2
              fi
          done
          continue
    fi

    if [[ ${file:7:1} == "r" ]]; then
          echo ${fileName}
    fi
done
