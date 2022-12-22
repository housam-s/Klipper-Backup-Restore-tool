# Klipper Github Backup
Backup Klipper config to github

## Instructions

For downloading this script it is necessary to have git installed.
If you haven't, please run `sudo apt-get install git -y` to install git first.

Assuming you already have a Github account 

1. Create a new GitHub repository
2. Create a token for access to the repo (Settings--Developer--Personal Access Tokens)
3. SSH To the printer and run the following commands (replace the values between [ ])

## Setting up Git

``` sudo apt-get install git -y
cd ~/klipper_config/
git init
git config --global user.name "[USERNAME]"
git config --global user.email "[EMAIL]"
git remote add origin https://[USERNAME]:[TOKEN]@[REPOSITORY URL]
git add .  (Note the ".", this is important)
git commit -m "Initial backup" 
git push -u origin master 
```

###### Note: This will only need to be done once as we will use a macro later to do this

## Setting up Klipper for backup

1. Open WinSCP and connect to your printer
2. Download the backup.sh file 
3. Copy the “backup.sh” file, updated with the correct credentials, into the pi folder. `/home/pi`
4. Copy the “gcode_shell_command.py”: file into the extras folder. `/klipper/klippy/extras` Download file from here 

5. Add the following to a macro or printer.cfg file

```
[gcode_shell_command backup_to_github]
command: sh /home/pi/backup.sh
timeout: 30.
verbose: True
```

```
[gcode_macro GITHUB_BACKUP]
gcode:
    RUN_SHELL_COMMAND CMD=backup_to_github
```    

This will create a macro button to run the backup. 
At this point, it is recommended to reboot the pi.

#### You can choose to automate this backup process by calling the macro or the backup.sh script. This can be setup to run as a cron or even at the start/end of a print. I will leave this up to you. 

