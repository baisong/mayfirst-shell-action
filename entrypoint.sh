#!/bin/sh -l

echo "Hello $1"
time=$(date)
echo "time=$time" >> $GITHUB_OUTPUT

# Log into red control panel to establish two factor auth for ssh/sftp purposes.
# Pass one argument, which is the path to a file with the contents of your username
# and password separated by a colon, e.g.:
# USERNAME:PASSWORD
apt-get -y install curl jq

! which curl >/dev/null && printf "Please install curl.\n" && exit 1
! which jq >/dev/null && printf "Please install jq.\n" && exit 1

url=https://members.mayfirst.org/cp/api.php
password_file="$1"

user=$2
password=$3
if [ -z "$user" -o -z "$password" ]; then
  printf "Failed to locate user and password in password file.\n"
  exit 1
fi
out=$(curl --silent "${url}" -X POST -d "user_name=$user" -d "user_pass=$password" -d "action=grant")
exit=$(echo "$out" | jq .is_error)
if [ "$exit" != "0" ]; then
  echo "$out" | jq
  exit 1
fi
exit 0
