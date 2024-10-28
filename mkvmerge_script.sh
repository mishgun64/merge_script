#!/bin/bash
IFS=$'\n'
clear
echo 'Mkvtoolnix install'
echo '------------------'

apt update -qq && apt install mkvtoolnix -y -qq
clear

echo 'Seclect action:'
echo '---------------'
echo '1) Add audio track'

read act

case $act in
    1)
        af=$(find -name "*.mka" | wc -l)
        if [ $af -gt 0 ]
        then
            echo
            echo
            echo 'Select audio:'
            echo '-------------'
            arr=$(find -type f -name "*.mka" | awk -F/ '{print $(NF-1)}' | uniq)

            select folder in $arr
            do
                break
            done

            echo
            echo
            echo $folder' selected. Merge starting...'
            echo
            echo
            sleep 2

            audio_folder=$(find $folder -type d )
            for container in ./*.mkv
            do
            name=${container##./}
            name=${name%%.mkv}
            audio_track=$audio_folder'/'$name'.mka'
            result_name=$name'_tmp.mkv'
            if [ -e $audio_track ]
            then
            echo $result_name
            echo $container
            echo $audio_track
            mkvmerge -o "$result_name"  "$container" --language 0:rus "$audio_track"
            rm $name'.mkv'
            mv $result_name $name'.mkv'
            chown plex:plex $name'.mkv'
            else
            echo ''
            echo ''
            echo '------------------------------------------------------------------------------------------------'
            echo "Audio file $audio_track not found!. File skiped"
            echo '------------------------------------------------------------------------------------------------'
            echo ''
            echo ''
            fi
            done
        else
            echo ''
            echo ''
            echo '------------------------------------------------------------------------------------'
            echo 'Audio files not found in this directory'
            echo '------------------------------------------------------------------------------------'
            echo ''
            echo ''
        fi
    ;;
esac