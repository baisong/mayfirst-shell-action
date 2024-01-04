#!/bin/sh -l

time=$(date)
echo "time=$time" >> $GITHUB_OUTPUT

! which curl >/dev/null && printf "Please install curl.\n" && exit 1
! which jq >/dev/null && printf "Please install jq.\n" && exit 1

url=https://members.mayfirst.org/cp/api.php
deploy_comment="$1"
user="$2"
password="$3"
echo "comment $deploy_comment"

out=$(curl --silent "${url}" -X POST -d "user_name=$user" -d "user_pass=$password" -d "action=grant")
exit=$(echo "$out" | jq .is_error)
if [ "$exit" != "0" ]; then
  echo "$out" | jq
  exit 1
fi

exit 0
