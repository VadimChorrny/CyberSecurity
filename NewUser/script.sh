function userAdd(){
    read -r -p "Do you want add user? " choice
     if [[ $choice == y || $chocie -eq yes ]]; then
         read -r -p "Enter user name: " user
        useradd $user
        if [[ $? != 0 ]]; then
            echo "$?"
            echo "Eroror user already exists"
        else 
            echo "User complited"
        fi
     else
         echo "Good bay"
     fi
}

function userDelete() {
    read -r -p 'Do you wand delete user' chocie
    if [[ $chocie == y || $chocie -eq yes ]]; then
        read -r -p "Enter user name: " user
        userdel $user
        if [[ $? != 0 ]]; then
        echo "$?"
        echo "User deleted!"
        else
            echo "Error user invalid"
        fi
        else
            echo "bb"
        fi
}

function changeUser() {
        read -r -p 'Do you wand change user' chocie
    if [[ $chocie == y || $chocie -eq yes ]]; then
        read -r -p "Enter user name: " user
        usermod -u UID $user
        read -r -p "Enter user name: " usernick
        usermod user -l $usernick
}

function createGroup() {
    read -r -p 'Do you wand create home group' chocie
    if [[ $chocie == y || $chocie -eq yes ]]; then
         vi /etc/sudoers
         %admin ALL=(ALL) ALL
         groupadd admin
        read -r -p "Enter user name: " user
        read -r -p "Enter user password: " password
         useradd $user -p $password
    echo "user complate"
    read -r -p 'Do you wand make user adminom?' chocie
    if [[ $chocie == y || $chocie -eq yes ]]; then
    usermod -a -G admin TestUser
    else
        echo "error"
    fi
}



function showMenu(){
    exit=true
    while [[ $exit == true ]]
    do
        echo -e "1. Add user\n2.Dell user\n3. Show all user\n 4.Create Home Group\n 5.Change profile users 0. Exit"
        read item
        case $item in
        1) userAdd;
        ;;
        2) userDelete;
        ;;
        3) cat /etc/passwd
        ;;
        4) createGroup;
        ;;
        5) changeUser;
        ;;
        0) exit=false
            echo "Good bay";;
        *) echo "Eroor invalid item"
            exit 1
        esac
    done
}


showMenu;
