#!/bin/bash

# реализация `ps ax` используя анализ /proc

shopt -s -o noclobber

# --- получаем массив PID
procs=$(ls -1 /proc/ | egrep [0-9] | sort -n)

printf "PID\tTTY\tSTAT\tTIME\tCOMMAND\n"

for pid in ${procs[@]}; do

  # --- TTY

  if [ -e "/proc/$pid/fd" ]; then
    tty=$(sudo readlink /proc/$pid/fd/0)
    tty="${tty#/dev/}"
  fi

  if [ -z "$tty" ] || [ "$tty" == "null" ]; then
    tty="?"
  fi

  # --- STAT

  if [ -e "/proc/$pid/status" ]; then
    state=$(cat /proc/$pid/status | grep "State" | awk '{print $2}')
  fi

  # --- TIME

  if [ -e "/proc/$pid/stat" ]; then
    utime=$(awk '{print $14}' "/proc/$pid/stat")
    stime=$(awk '{print $15}' "/proc/$pid/stat")
    cpu_time=$((utime + stime))

    minutes=$((cpu_time / 60))
    seconds=$((cpu_time % 60))

    time=$(printf "%02d:%02d" "$minutes" "$seconds")
  fi

  # --- COMMAND

  if [ -e "/proc/$pid/cmdline" ]; then
    cmd=$(cat /proc/$pid/cmdline | tr -d '\0')
  fi

  if [ -z "$cmd" ] && [ -e "/proc/$pid/status" ]; then
    cmd=$(head -1 /proc/$pid/status | awk '{print "["$2"]"}')
  fi

  line=$(printf "%d\t%s\t%s\t%s\t%s\n" "$pid" "$tty" "$state" "$time" "$cmd")
  echo "${line:0:120}"
done
