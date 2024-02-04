#Restore your latest backup from Github
restore(){
  cd ~/printer_data/config
  echo Retrieving updates
  sleep 1
  git fetch
  git reset --hard origin/master
}
restore
