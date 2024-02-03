#!/bin/bash
###########################
## Klipper Backup Script ##
#### Created by m00se #####
###########################

#Download gcode_shell_command.py and place it in~/klipper/klippy/extras/
addshellcommand(){ 
  cd ~/klipper/klippy/extras/
  wget -q https://raw.githubusercontent.com/housam-s/Klipper-Backup/main/gcode_shell_command.py
  echo gcode_shell_command.py is now present
}

#Download backup macro and add it to ~/printer_data/config/printer.cfg
addmacro(){  
  sed -i '1 i\[include backup.cfg]\n' ~/printer_data/config/printer.cfg
  echo backup.cfg has been included in printer.cfg
  cd ~/printer_data/config/
  wget -q https://raw.githubusercontent.com/housam-s/Klipper-Backup/main/backup.cfg
  sed -i 's|replaceme|/home/'$USER'/backup.sh |g' ~/printer_data/config/backup.cfg
  echo backup.cfg is now present
}

#Setup Git connectivity in ~/printer_data/config
getgit(){
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

  cd ~/printer_data/config
  git init
  sleep 1
  git config --global user.name "$vargitusername"
  git config --global user.email "$vargitemail"
  git remote add origin https://$vargitusername:$vargittoken@$vargitrepo
  git add .
  git commit -m "Initial backup"
  git push -u origin master
  sleep 1
  echo Setup Completed
  exit
}

#Backup ~/printer_data/config and push it to Github
push_config(){
  cd ~/printer_data/config
  echo Pushing updates
  sleep 1
  git pull -v
  sleep 1
  git add . -v
  sleep 1
  current_date=$(date +"%Y-%m-%d %T")
  git commit -m "Backup triggered on $current_date" -m "$m1" -m "$m2" -m "$m3" -m "$m4"
  git push -u origin master
}

#Controlling Task
run(){
  shellcommandpath=~/klipper/klippy/extras/gcode_shell_command.py
  if [ ! -f "$shellcommandpath" ]; then
    echo gcode_shell_command.py is not present
    addshellcommand
  fi
  macropath=~/printer_data/config/backup.cfg
  if [ ! -f "$macropath" ]; then
    echo Macro not installed
    addmacro
  fi
  gitpath=~/printer_data/config/.git
  if [ ! -d "$gitpath" ]; then
    echo Git not configured
    getgit
  fi
  sleep 1
  push_config
  sleep 1
}

run