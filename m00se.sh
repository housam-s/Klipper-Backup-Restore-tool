#!/bin/bash
###########################
## Klipper Backup Script ##
#### Created by m00se #####
###########################

###GIT###

#Setup Git connectivity in ~/printer_data/config **Required for new or restore procedures
gitinit(){
  printf "\n"
  echo What is your Git Username?
  read vargitusername
  sleep 1

  echo What is your Git Email Address?
  read vargitemail
  sleep 1

  echo What is your Git Token
  read vargittoken
  sleep 1

  echo What is your Git Repository URL
  read vargitrepo

  printf "\nYou have provided the following Git details:"
  printf "\nGit Username: $vargitusername"
  printf "\nGit Email Address: $vargitemail"
  printf "\nGit Token: $vargittoken"
  printf "\nGit Repo: $vargitrepo\n"
  
  printf "\nIf these details are correct type yes otherwise press any key: "
  read vargitresponse

  if [ "$vargitresponse" != "y" -a "$vargitresponse" != "Y" -a "$vargitresponse" != "Yes" -a "$vargitresponse" != "yes" ]; then
    gitinit
  fi

  cd ~/printer_data/config
  git init
  sleep 1
  git config --global user.name "$vargitusername"
  git config --global user.email "$vargitemail"
  git remote add origin https://$vargitusername:$vargittoken@$vargitrepo
}

#Creates first backup when setting up the script for the first time
gitnew(){
  cd ~/printer_data/config/
  git add .
  git commit -m "Initial backup"
  git push -u origin master
  sleep 1
  echo Setup has been completed
}


###gcode_shell_command.py###

#Download gcode_shell_command.py and place it in~/klipper/klippy/extras/
addshellcommand(){ 
  cd ~/klipper/klippy/extras/
  wget -q https://raw.githubusercontent.com/housam-s/Klipper-Backup-Restore-tool/main/gcode_shell_command.py
  sleep 1
}

##Configuration Files###

#Download backup.cfg and add it to ~/printer_data/config/
addbackupcfg(){
  cd ~/printer_data/config/
  wget -q https://raw.githubusercontent.com/housam-s/Klipper-Backup-Restore-tool/main/backup.cfg
  printf "\n[Backup Config File]\n"
  echo backup.cfg has been downloaded and placed in ~/printer_data/config/
  sleep 1
  sed -i 's|replaceme|/home/'$USER'/backup_command.sh |g' ~/printer_data/config/backup.cfg
  echo backup path has been added to the backup.cfg
  sleep 1
}

#Download restore.cfg and add it to ~/printer_data/config/
addrestorecfg(){
  cd ~/printer_data/config/
  wget -q https://raw.githubusercontent.com/housam-s/Klipper-Backup-Restore-tool/main/restore.cfg
  printf "\n[Restore Config File]\n"
  echo restore.cfg has been downloaded and placed in ~/printer_data/config/
  sleep 1
  sed -i 's|replaceme|/home/'$USER'/restore_command.sh |g' ~/printer_data/config/restore.cfg
  echo backup path has been added to the restore.cfg
  sleep 1
}

##MACROS###

#Add a macro to include backup.cfg into printer.cfg
addbackupmacro(){  
  sed -i '1 i\[include backup.cfg]\n' ~/printer_data/config/printer.cfg
  sleep 1
}

#Add a macro to include restore.cfg into printer.cfg
addrestoremacro(){   
  sed -i '1 i\[include restore.cfg]\n' ~/printer_data/config/printer.cfg
  sleep 1
}

addbackupcommand(){
    cd /home/$USER/
    if [ ! -f "backup_command.sh" ]; then
      wget -q https://raw.githubusercontent.com/housam-s/Klipper-Backup-Restore-tool/main/backup_command.sh
      
    fi
}

#The backup command to push backups to githhub
backupcommand(){
    /bin/bash backup_command.sh
    exit
}

addrestorecommand(){
    cd /home/$USER/
    if [ ! -f "restore_command.sh" ]; then
      wget -q https://raw.githubusercontent.com/housam-s/Klipper-Backup-Restore-tool/main/restore_command.sh
    fi
}

restorecommand(){
    /bin/bash restore_command.sh
    exit
}

checks(){
  #Check if gcode_shell_command.py is installed if not download and add it
  shellcommandpath=~/klipper/klippy/extras/gcode_shell_command.py
  if [ ! -f "$shellcommandpath" ]; then
    printf "\n[Shell Command]\n"
    echo gcode_shell_command.py is not in Klippy Extras
    sleep 1
    addshellcommand
    echo gcode_shell_command.py has now been added to Klippy Extras
  fi
  
  #Check if backup.cfg exists, if not download and add it
  backupcfg=~/printer_data/config/backup.cfg
  if [ ! -f "$backupcfg" ]; then
    printf "\n[Backup Config]\n"
    echo backup.cfg has now been downloaded and configured
    sleep 1
    addbackupcfg
    addbackupmacro
    echo backup.cfg has been included in printer.cfg
  fi

  #Check if restorecfg.cfg exists, if not download and add it
  restorecfg=~/printer_data/config/restore.cfg
  if [ ! -f "$restorecfg" ]; then
    printf "\n[Restore Config]\n"
    echo restore.cfg has now been downloaded and configured
    sleep 1
    addrestorecfg
    addrestoremacro
    echo restore.cfg has been included in printer.cfg
  fi

  #Check if backup_command.sh exists, if not download
  backupcommandsh=/home/$USER/backup_command.sh
  if [ ! -f "$backupcommandsh" ]; then
    sleep 1
    printf "\n[Backup Command Script]\n"
    echo backup_command.sh does not exist, downloading file....
    addbackupcommand
    echo backup_command.sh has now been downloaded
  fi

  #Check if restore_command.sh exists, if not download
  restorecommandsh=/home/$USER/restore_command.sh
  if [ ! -f "$restorecommandsh" ]; then
    sleep 1
    printf "\n[Restore Command Script]\n"
    echo restore_command.sh does not exist, downloading file....
    addrestorecommand
    echo restore_command.sh now been downloaded
  fi
  
  #Check if git has been configured in ~/printer_data/config/.git
  gitpath=~/printer_data/config/.git
  if [ ! -d "$gitpath" ]; then
    echo Git has not been configured yet
    sleep 1
    gitinit
  fi
  sleep 1
}

addrestorecommand(){
    cd /home/$USER/
    if [ ! -f "restore_command.sh" ]; then
      echo restore_command.sh does not exist, downloading file....
      wget -q https://raw.githubusercontent.com/housam-s/Klipper-Backup-Restore-tool/main/restore_command.sh
    fi
}

restorecommand(){
    /bin/bash restore_command.sh
    checks
    exit
}

#Controlling Task
run(){
  printf "Klippy Backup\nCreated by m00se"
  gitpath=~/printer_data/config/.git
  if [ ! -d "$gitpath" ]; then
    printf '\n\nAre you configuring backups for a new printer or restoring from an old one?\n'
    select option in New Restore
    do
            case $option in 
            New|Restore)   
                    break
                    ;;
            *)
                    echo "Invalid selection" 
                    ;;
            esac
    done
  
    if [ $option = "New" ]; then
      gitinit
      checks
      gitnew
      printf "\nSetup Completed\n"
      exit
    elif [ $option = "Restore" ]; then
      gitinit
      checks
      restorecommand
      printf "\nRestore Completed\n"
      exit
    fi
  fi
  
  printf "\nConfirming requirements are met\n"
  checks

  printf '\nPlease select one of the following options\n'

  select option in Backup Restore
  do
          case $option in 
          Backup|Restore)   
                  break
                  ;;
          *)
                  echo "Invalid selection" 
                  ;;
          esac
  done

  if [ $option = "Backup" ]; then
    addbackupcommand
    backupcommand
  elif [ $option = "Restore" ]; then
    addrestorecommand
    restorecommand
  fi
}
run
