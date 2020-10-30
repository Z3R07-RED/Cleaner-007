#!/data/data/com.termux/files/usr/bin/bash
#cleaner-007
#Coded by Z3R07-RED on Jun 18 2020

if [[ -f ".config/.dialog.conf" ]]; then
    export DIALOGRC=.config/.dialog.conf
fi
DIALOG=${DIALOG=dialog}
Help="\n\
\ZuCLEANER-007 (c) 2020 by Z3R07-RED\Zn\n\
It is a program that is responsible for deleting\n\
junk files on Android devices, such as caches and empty files.\n\n\
This program will not harm the device.
"

SCAN="./logs/Scanned_files.log"
obsolete_logs="./logs/obsolete.log"

if [[ -s .config/data.conf ]]; then
    source .config/data.conf
else
    echo "Error: './.config/data.conf'"
    echo ""
    exit
fi

if [[ ! -d ./tmp ]]; then
    mkdir tmp
fi

if [[ ! -d ./logs ]]; then
    mkdir logs
fi

trap ctrl_c INT

function ctrl_c(){
echo "export crun=\"False\"" > ./tmp/Stop.tmp
echo "export Finished=\"finished\"" >> ./tmp/Stop.tmp
echo $(clear)
echo "Program aborted."
echo ""
rm -rf logs/* &> /dev/null
sleep 0.2
tput cnorm;exit 1
}

function dependencies(){
tput civis
echo $(clear); dependencies=(dialog file play-audio)
echo -e "\e[1;37mCleaner-007\e[0m"
echo ""
echo "Coded by Z3R07 on Jun 18 2020"
echo ""
echo -e "\033[1;37m[+]\033[0m\e[0m Checking the required tools ...\033[0m\e[0m"
for program in "${dependencies[@]}"; do
    echo -ne "\n\e[0m[*] Tool $program ..."
    test -f $PREFIX/bin/$program
    if [ "$(echo $?)" == "0" ]; then
        echo " (V)"
    else
        echo -e " \e[1;31m(X)\e[0m"
        echo -e "\n[=] Installing '$program' tool ..."
        apt-get install $program -y > /dev/null 2>&1

    fi; sleep 1
done
}

function var_grep(){
let list_num=1
let grep_residual=$(echo "$_setting" |grep 'residual' |wc -l)
let grep_obsolete=$(echo "$_setting" |grep 'Obsolete' |wc -l)
let grep_thumbnail=$(echo "$_setting"|grep 'Thumbnail'|wc -l)
let grep_folders=$(echo "$_setting" | grep 'folders' | wc -l)
resultadog=($grep_residual "$grep_obsolete" "$grep_thumbnail" "$grep_folders")
}

function C_SETTING(){
_setting=$($DIALOG --stdout --colors --clear \
    --ok-label "Submit" \
    --backtitle "CLEANER-007" \
    --title "SETTING" \
    --checklist "Press the \Zb\Z4\Zu'Space'\Zn key to mark an option and then \Zb\Z4\Zu'Enter'\Zn to configure." 15 61 5 \
    "Unwanted residual data" "" $unwanted_residual_data \
    "Obsolete APKs" "" $obsolete_apks \
    "Thumbnail Cache" "" $thumbnail_cache \
    "Empty folders" "" $empty_folders)

Activate=$?
case $Activate in
    0)
        var_grep
        if [[ -f .config/data.conf ]]; then
            rm .config/data.conf
            echo "#!/bin/bash" > .config/data.conf
        else
            echo "#!/bin/bash" > .config/data.conf
        fi
        for conf07 in ${resultadog[@]};
        do
            if [[ $conf07 != 0 ]]; then
                if [[ $list_num == 1 ]]; then
                    echo "unwanted_residual_data=\"ON\"" >> .config/data.conf
                    unwanted_residual_data="ON"
                elif [[ $list_num == 2 ]]; then
                    echo "obsolete_apks=\"ON\"" >> .config/data.conf
                    obsolete_apks="ON"
                elif [[ $list_num == 3 ]]; then
                    echo "thumbnail_cache=\"ON\"" >> .config/data.conf
                    thumbnail_cache="ON"
                elif [[ $list_num == 4 ]]; then
                    echo "empty_folders=\"ON\"" >> .config/data.conf
                    empty_folders="ON"
                fi
            else
                if [[ $list_num == 1 ]]; then
                    echo "unwanted_residual_data=\"OFF\"" >> .config/data.conf
                    unwanted_residual_data="OFF"
                elif [[ $list_num == 2 ]]; then
                    echo "obsolete_apks=\"OFF\"" >> .config/data.conf
                    obsolete_apks="OFF"
                elif [[ $list_num == 3 ]]; then
                    echo "thumbnail_cache=\"OFF\"" >> .config/data.conf
                    thumbnail_cache="OFF"
                elif [[ $list_num == 4 ]]; then
                    echo "empty_folders=\"OFF\"" >> .config/data.conf
                    empty_folders="OFF"
                fi
            fi
            let list_num=$(($list_num+1))
        done
        sleep 0.2
        play-audio Sounds/Sound.m4a &
        $DIALOG --backtitle "CLEANER-007" \
            --title "SETTING" \
            --msgbox "\n\nConfiguration completed! :)" 10 60
        clean_007
        ;;
    1)
        clean_007
        ;;
    255)
        echo $(clear);tput cnorm
        echo "Finished Program."
        echo "";exit 1
        ;;
esac

}

function file_list_select(){
tput cnorm
enter_the_file=$($DIALOG --stdout --colors \
    --backtitle "CLEANER-007" \
    --title "FILE LIST" \
    --inputbox "Enter the full path of the file that contains the list of files to be deleted.\n\n\Z0\ZrEnter the file:\Zn " 12 60 "$HOME/")
case $? in
    0)
        if [[ -f ./logs/HRM.log ]]; then
            rm -f ./logs/HRM.log
            touch ./logs/HRM.log
        else
            touch ./logs/HRM.log
        fi
        if [[ -f "$enter_the_file" && -s "$enter_the_file" ]]; then
            _Z3R07_ENTER=$(awk "NR==1" "$enter_the_file")
            if [[ -f "$_Z3R07_ENTER" || -d "$_Z3R07_ENTER" ]]; then
                tput civis
                obsolete_logs="$enter_the_file"
                removing_obsolete_files
            else
                play-audio Sounds/Error.mp3 &
                $DIALOG --colors --backtitle "CLEANER-007" --title "ERROR" --msgbox "\Z1\ZrERROR:\Zn\n'\Zb\Z4\Zu$enter_the_file\Zn':\n\nline 1 '\Z1\Zu$_Z3R07_ENTER\Zn': No such file or directory." 13 60
                echo $(clear)
                echo "Program aborted."
                echo "";exit 1
            fi
        else
            play-audio Sounds/Error.mp3 &
            $DIALOG --colors --backtitle "CLEANER-007" --title "ERROR" --msgbox "\Z0\ZrERROR:\Zn\n'\Z1\Zu$enter_the_file\Zn':\nNo such file exists." 10 60
            echo $(clear)
            echo "Finished Program."
            echo "";exit 1
        fi
        ;;
    1)
        tput civis
        clean_007
        ;;
    255)
        echo $(clear)
        echo "Program aborted."
        echo "";exit 1
        ;;
esac
}

function clean_on(){
if [[ "$Ejecutar" == "SETTING" ]]; then
C_SETTING

elif [[ "$Ejecutar" == "FILE LIST" ]]; then
    file_list_select

elif [[ "$Ejecutar" == "HISTORY" ]]; then
    if [[ -s logs/HRM.log ]]; then
        $DIALOG --backtitle "CLEANER-007" \
            --title "HISTORY" \
            --exit-label "Ok" \
            --textbox ./logs/HRM.log 15 60

        clean_007
    else
        $DIALOG --backtitle "CLEANER-007" \
            --title "HISTORY" \
            --msgbox "History not found." 7 40

        clean_007
    fi

elif [[ "$Ejecutar" == "ANALYZE" ]]; then
	if [[ -f ./tmp/run.tmp ]]; then
		rm ./tmp/run.tmp
    fi
	echo "$Ejecutar" > ./tmp/run.tmp
	if [[ -f $SCAN ]]; then
		rm $SCAN
	fi
	printf "[!] DO NOT INTERRUPT SCANNING\n\n" > $SCAN
	sleep 0.1
	./RMD &
    while :
    do
	$DIALOG --clear --backtitle "CLEANER-007" \
            --exit-label "Accept" \
			--title "SCAN PROGRESS" \
			--tailbox "$SCAN" 13 60

    source ./tmp/Stop.tmp
    [ "$Finished" == "finished" ] && {
            if [[ -f ./tmp/Stop.tmp ]]; then
                rm ./tmp/Stop.tmp
            fi
            break
        }
    $DIALOG --backtitle "CLEANER-007" \
        --title "SCAN PROGRESS" \
        --infobox "\nPlease wait a few minutes to continue.\n\n\
Scan in progress ..." 10 60 ; sleep 3
    done

    if [[ -f "$SCAN" ]]; then
        rm -f $SCAN &> /dev/null
    fi
    sleep 0.5
    $DIALOG --backtitle "CLEANER-007" \
           --title "OBSOLETE FILES" \
           --exit-label "Start Cleaning" \
           --textbox ./logs/obsoleteM.log 15 60 \
           --and-widget --title "CLEANER-007" \
           --yesno "Do you want to delete all junk files?" 8 50

	selec=$?
	case $selec in
			0)
                rm -f ./logs/obsoleteM.log
                removing_obsolete_files
				;;
            1)
                rm -f ./logs/obsoleteM.log
                echo $(clear)
                echo "Program aborted."
                echo ""
                tput cnorm;exit
                ;;
			255)
				echo $(clear)
                echo "Program aborted."
                echo ""
                rm -f ./logs/obsoleteM.log
                tput cnorm;exit 1
				;;
	esac
    tput cnorm;exit
else
    if [[ -f ./tmp/run.tmp ]]; then
		rm ./tmp/run.tmp
	fi
	echo "$Ejecutar" > ./tmp/run.tmp
	sleep 0.1
	./RMD &
    while :
    do
        $DIALOG --backtitle "CLEANER-007" \
            --colors \
            --title "DISK SPACE LIBERATOR" \
            --infobox "\Zr\Z0CLEANER-007:\Zn\n\nThe space liberator is calculating the space that can be freed.\n\nThis operation may take several minutes." 10 60 ; sleep 3

        source ./tmp/Stop.tmp
        [ "$Finished" == "finished" ] && {
            if [[ -f ./tmp/Stop.tmp ]]; then
                rm ./tmp/Stop.tmp
                break
            fi
        }
        $DIALOG --backtitle "CLEANER-007" \
            --title "DISK SPACE LIBERATOR" \
            --infobox "\n\nPlease wait ..." 10 60 ; sleep 3
    done

    removing_obsolete_files
    echo $(clear);tput cnorm
    exit 0
fi

}

function removing_obsolete_files(){
let _counter=0
let _TOLGF=$(cat "$obsolete_logs" |wc -l)
let _aucounter=0

play-audio Sounds/cleaner.mp3 &
(while [ $_counter -le 100 ]
do

cat <<EOF
XXX
$_counter
\Zr\Z0CLEANER-007:\Zn Removing obsolete files ...
OBSOLETE ($_aucounter):
XXX
EOF
for zero in $(seq 1 10);
do
    if [[ $_aucounter != $_TOLGF ]]; then
        let _aucounter=$(($_aucounter+1))
        _auline=$(awk "NR==$_aucounter" "$obsolete_logs")
        if [[ -f "$_auline" ]]; then
            rm -rf "$_auline" &> /dev/null
            printf "[ %02d - f ] Deleted: $_auline\n" $_aucounter >> ./logs/HRM.log
        elif [[ -d "$_auline" ]]; then
            rm -rf "$_auline" &> /dev/null
            printf "[ %02d - d ] Deleted: $_auline\n" $_aucounter >> ./logs/HRM.log
        fi
    fi
done

if [[ $_counter != 90 ]]; then
    ((_counter+=10))
    sleep 1
else
    if [[ $_aucounter == $_TOLGF ]]; then
        echo "$(date)" >> ./logs/HRM.log
        echo "CLEANING COMPLETED: [$_TOLGF]" >> ./logs/HRM.log
        if [[ -f logs/obsolete.log ]]; then
            rm -f ./logs/obsolete.log &> /dev/null
        fi
        ((_counter+=10))
        sleep 1
    fi
fi
done) | $DIALOG --colors --backtitle "CLEANER-007" --title "DISK SPACE LIBERATOR" --gauge "...." 7 70

$DIALOG --backtitle "CLEANER-007" \
    --title "CLEANING COMPLETED" \
    --msgbox "\nCLEANING COMPLETED: [$_TOLGF]" 10 50

echo $(clear);tput cnorm
echo "Program terminated."
echo "";exit 0
}

function clean_007(){
while :
do
		Ejecutar=$($DIALOG --stdout --help-button \
                          --ok-label "Select" \
						  --cancel-label "Exit" --item-help \
	                      --backtitle "CLEANER-007" \
	                      --title "MENU" \
                          --menu "1.0" 15 51 5 \
				          "SETTING" "Program settings" "It is recommended to configure the program." \
				          "CLEAN ALL" "Deep cleaning" "Clean up obsolete files and directories?" \
                          "ANALYZE" "Scan Android" "Do you want to scan the mobile device?" \
                          "HISTORY" "Cleaning history" "Registry of files and directories deleted." \
                          "FILE LIST" "Add a list" "You can delete a list of obsolete files or directories.")
		[ $? -ne "2" ] && {
			break
	    }
        $DIALOG --colors --backtitle "CLEANER-007" --title "HELP" --msgbox "$Help" 13 60

done

if [[ -n $Ejecutar ]]; then
	clean_on
else
	echo $(clear);tput cnorm
    echo "Exiting ..."
	echo "";exit
fi
}

if [[ -f "RMD" && -x "RMD" ]]; then
    dependencies
else
    if [[ -f "RMD" ]]; then
        chmod +x RMD
        dependencies
    else
        echo ""
        echo "[cleaner-007]: The file './RMD' does not exist."
        echo ""
        exit 0
    fi
fi
echo $(clear)
sleep 0.8
play-audio Sounds/cleaner.mp3 &
$DIALOG --colors --title "CLEANER-007" \
    --infobox "\n\ZuCLEANER-007 (c) 2020 by Z3R07-RED\Zn\n\nThis program comes ABSOLUTELY WITHOUT WARRANTY;\nthanks for using the program." 10 60 ;sleep 5
clean_007
