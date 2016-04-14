#!/bin/bash
#

DISPATCHER_LEAP_FOLDER=/var/lib/pixelated/dispatcher
DESTINATION_LEAP_FOLDER=/var/lib/pixelated/.leap

hash ls $DESTINATION_LEAP_FOLDER 2>/dev/null || mkdir -p $DESTINATION_LEAP_FOLDER
hash jq 2>/dev/null || apt-get install jq

echo $all_users
echo 'about to copy user soledad client folders'
for user in $(ls $DISPATCHER_LEAP_FOLDER)
do
    user_id=$(/usr/bin/curl -s --netrc-file /etc/couchdb/couchdb.netrc '127.0.0.1:5984/identities/_all_docs?include_docs=true' | grep 'address":"'$user'@' | jq -r '.doc.user_id' 2> /dev/null)
    echo 'User '$user', User ID' $user_id

    # if no user id
    if [ -z $user_id ] || [ $user_id = 'null' ]; then
         echo 'skipping...'
         continue
    fi

    leap_folder=$DISPATCHER_LEAP_FOLDER/$user/data/$user_id
    if [ -d $leap_folder ]; then
        cp -r $leap_folder $DESTINATION_LEAP_FOLDER
    else
       data_folder=$DISPATCHER_LEAP_FOLDER/$user/data
       mkdir -p $DESTINATION_LEAP_FOLDER/$user_id
       cp -r $data_folder/providers $DESTINATION_LEAP_FOLDER/$user_id
       cp -r $data_folder/search_index $DESTINATION_LEAP_FOLDER/$user_id
       cp -r $data_folder/soledad $DESTINATION_LEAP_FOLDER/$user_id
    fi
    echo 'done with user' $user
done

echo "******* data moved ********"