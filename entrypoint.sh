#!/bin/sh -l

echo "Hello $1"
time=$(date)
echo "time=$time" >> $GITHUB_OUTPUT

! which curl >/dev/null && printf "Please install curl.\n" && exit 1
! which jq >/dev/null && printf "Please install jq.\n" && exit 1

url=https://members.mayfirst.org/cp/api.php
password_file="$1"
user="$2"
password="$3"
echo "url $url"
echo `expr substr ${url} 0 5`
echo "user $2"
echo `expr substr ${2} 0 5`
echo "password $3"
echo `expr substr ${3} 0 5`

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
