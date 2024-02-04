#Restore your backup from Github
restore(){
  cd ~/printer_data/config
  echo Retrieving updates
  sleep 1
  git pull -v
}
restore
