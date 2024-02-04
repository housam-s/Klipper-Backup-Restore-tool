#Complete a backup and push it to Github
backup(){
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
backup
