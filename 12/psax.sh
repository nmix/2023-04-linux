#!/bin/bash

# реализация `ps ax` используя анализ /proc

shopt -s -o noclobber

# --- получаем массив PID
procs=$(ls -1 /proc/ | egrep [0-9] | sort -n)

printf "PID\t\tCOMMAND\n"

for pid in ${procs[@]}; do
  if [ -e "/proc/$pid/cmdline" ]; then
    name=$(cat /proc/$pid/cmdline | tr -d '\0')
  fi

  if [ -z "$name" ] && [ -e "/proc/$pid/status" ]; then
    name=$(head -1 /proc/$pid/status | awk '{print "["$2"]"}')
  fi

  line=$(printf "%d\t\t%s\n" "$pid" "$name")
  echo "${line:0:120}"
done
