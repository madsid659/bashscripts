#!/bin/bash
#CreatedBy Sidharthan
username=$1
public_key_filename=$2
key_pwd=`pwd`

check_args(){
    if [ -n "$username" ]
    then
            echo "username is $username"
    else
            echo "provide 1st arg" && exit
    fi
    if [ -n "$public_key_filename" ]
    then
            echo "publickey filename is is $public_key_filename"
    else
            echo "provide 2nd arg" && exit
    fi
    if [ -f $key_pwd/$public_key_filename ]
    then
            echo "confirmed key exist"
    else
            echo "keyfile not found in pwd" && exit
    fi

}
check_user_exist(){
        username_exist=$(awk -F ":" '{printf $1 "\n"}' /etc/passwd | grep "^${username}$")

        if [ ! -z ${username_exist} ] ; then
            echo "Username $username exist, please change it"
            exit
        fi
}

add_user(){
    useradd -d "/home/$username" -m -s /bin/bash $username
    if [ $? == 0 ]
    then
            echo "Created user: $username"
    else
            echo "echo error creating user $username" && exit
    fi
}
check_authrized_keys(){
    test -d /home/$username/.ssh && cd /home/$username/.ssh || mkdir /home/$username/.ssh && echo "created .ssh folder"
    test -f /home/$username/.ssh/authorized_keys && echo "authorized_keys already exist" || touch /home/$username/.ssh/authorized_keys && chown $username:$username /home/$username/.ssh/authorized_keys && chmod 600 /home/$username/.ssh/authorized_keys
}
copy_authrized_keys(){
    test -f $key_pwd/$public_key_filename && cat $key_pwd/$public_key_filename >> /home/$username/.ssh/authorized_keys && echo "added public key to authrized hosts" &&\
    rm -rf  $key_pwd/$public_key_filename && echo "removed public key file" || echo "error: not found keyfile"
}
check_args
check_user_exist
add_user
check_authrized_keys
copy_authrized_keys
