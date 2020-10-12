#!/bin/bash
function printMenu(){

echo -e "1) Add user"
echo -e "  a) Name"
echo -e "  b) name + uid"
echo -e "  c) add password to user and uid"
echo -e "2)Delete user"
echo -e "3) Edit user"
echo -e "  a) Name"
echo -e "  b) id"
echo -e "  c) gid"
echo -e "4)Create group (with gid)"
echo -e "5)Add user to group"
echo -e "6)Drop user from group"
echo -e "7)Show all users"
echo -e "0)Exit"

}
function adduser_name(){
    read -r -p "Enter user name: " nameuser
    sudo adduser $nameuser
}
function adduser_name_uid(){
    read -r -p "Enter user name " nameuser
    read -r -p "Enter user id" uiduser
    sudo useradd -u $uiduser $nameuser
}
function add_pass(){
    read -r -p "Enter user name: " nameuser
    sudo passwd $nameuser
}
function del_user(){
    read -r -p "Enter user name:" nameuser
    sudo userdel $nameuser
}
function editName(){
    read -r -p "Enter user name:" newusername
    read -r -p "Enter old name" oldusername
    sudo usermod -l $newusername $oldusername
}
function editId(){
    read -r -p "Enter new user id: " newuid
    read -r -p "Enter user name:" username
    sudo usermod -u $new_uid $username
}
function editGid(){
    read -r -p "Enter new user id" newgid
    read -r -p "Enter groupname" groupname
    sudo groupmod -g $newgid $groupname
}
function addGroup(){
    read -r -p "Enter GID" gid_
    read -r -p "Enter groupname" groupname
    sudo addgroup --gid $gid_ $groupname
}
function adduserToGroup(){
    read -r -p "Enter groupname" groupname
    read -r -p "Enter username: " username
    sudo usermod -a -G $groupname $username
}
function deluserFromGroup(){
    read -r -p "Enter groupname: " groupname
    read -r -p "Enter username: " username
    sudo usermod -R $groupname $username
}
function showAllUsers(){
    cat /etc/passwd | awk -F: '{print $1}'
}
exit=false 
echo -e "---===USER MENU===---"
while [[ $exit != true ]]
do
    printMenu;
    read -r -p "Enter your answer: " answer
    case "$answer" in
    "0")
    exit=true
    ;;
    "1")
    read -r -p "Enter your answer: " answer1
    if [[ "$answer1" == "a" ]]; then
    adduser_name;
    elif [[ "$answer1" == "b" ]]; then
    editId;
    elif [[ "$answer1" == "c" ]]; then
    add_pass;
    else
    echo -e "error user invalid"
    fi
    ;;
    "2")
    del_user;
    ;;
    "3")
    read -r -p "Enter your answer " answer3
    if [[ "$answer3" == "a" ]]; then
    editName;
    elif [[ "$answer3" == "b" ]]; then
    editGid;
    elif [[ "$answer3" == "c" ]]; then
    editGid;
    else
    echo -e "error"
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
    echo -e "Good Bye"
    exit 1
    ;;
    esac
done