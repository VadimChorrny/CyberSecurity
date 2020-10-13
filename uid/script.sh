#!/bin/bash
function printMenu(){
echo -e "..................................................."
echo -e ".  1. ADD USER                                    ."                                   
echo -e ".  a) Name                                        ."                            
echo -e ".  b) name + uid                                  ."
echo -e ".  c) add password to user and uid                ."
echo -e ".  2. DELETE USER                                 ."
echo -e ".  3) Edit user                                   ."
echo -e ".  a) Name                                        ."
echo -e ".  b) id                                          ."
echo -e ".  c) gid                                         ."
echo -e ".  4. CREATE GROUP (with gid)                     ."
echo -e ".  5. Add user to group                           ."
echo -e ".  6. Drop user from group                        ."
echo -e ".  7. Show all users                              ."
echo -e ".  0. EXIT                                        ."
echo -e "..................................................."

}
function adduser_name(){
    read -r -p "ENTER USER NAME " nameuser
    sudo adduser $nameuser
}
function adduser_name_uid(){
    read -r -p "ENTER USER NAME " nameuser
    read -r -p "ENTER USER UID" uiduser
    sudo useradd -u $uiduser $nameuser
}
function add_pass(){
    read -r -p "ENTER USER NAME" nameuser
    sudo passwd $nameuser
}
function del_user(){
    read -r -p "ENTER USER NAME" nameuser
    sudo userdel $nameuser
}
function editName(){
    read -r -p "ENTER NEW USERNAME" newusername
    read -r -p "ENTER OLD USERNAME" oldusername
    sudo usermod -l $newusername $oldusername
}
function editId(){
    read -r -p "ENTER NEW UID" newuid
    read -r -p "ENTER USERNAME" username
    sudo usermod -u $new_uid $username
}
function editGid(){
    read -r -p "ENTER NEW UID" newgid
    read -r -p "ENTER GROUPNAME" groupname
    sudo groupmod -g $newgid $groupname
}
function addGroup(){
    read -r -p "ENTER GID" gid_
    read -r -p "ENTER GROUPNAME" groupname
    sudo addgroup --gid $gid_ $groupname
}
function adduserToGroup(){
    read -r -p "ENTER GROUPNAME" groupname
    read -r -p "ENTER USERNAME" username
    sudo usermod -a -G $groupname $username
}
function deluserFromGroup(){
    read -r -p "ENTER GROUPNAME" groupname
    read -r -p "ENTER USERNAME" username
    sudo usermod -R $groupname $username
}
function showAllUsers(){
    cat /etc/passwd | awk -F: '{print $1}'
}
exit=false 
while [[ $exit != true ]]
do
    printMenu;
    read -r -p "ENTER YOUR ANSWER... " answer
    case "$answer" in
    "0")
    exit=true
    ;;
    "1")
    read -r -p "ENTER YOUR ANSWER... " answer1
    if [[ "$answer1" == "a" ]]; then
    adduser_name;
    elif [[ "$answer1" == "b" ]]; then
    editId;
    elif [[ "$answer1" == "c" ]]; then
    add_pass;
    else
    echo -e "ERROR"
    fi
    ;;
    "2")
    del_user;
    ;;
    "3")
    read -r -p "ENTER YOUR ANSWER... " answer3
    if [[ "$answer3" == "a" ]]; then
    editName;
    elif [[ "$answer3" == "b" ]]; then
    editGid;
    elif [[ "$answer3" == "c" ]]; then
    editGid;
    else
    echo -e "ERROR"
    fi
    ;;
    "4")
    addGroup;
    ;;
    "5")
    adduserToGroup;
    ;;
    "6")
    deluserFromGroup;
    ;;
    "7")
    showAllUsers;
    ;;
    *)
    echo -e "INVALID ITEM"
    exit 1
    ;;
    esac
done