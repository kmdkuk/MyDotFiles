#!/usr/bin/env bash

set -euCo pipefail

function separator() {
  [[ $# -lt 1 ]] && return 1
  output --color-name $1 --string ''
}

function output() {
  [[ $# -lt 2 ]] && return 1

  local -rA colors=(
    ['black']='#[fg=black,bg=yellow]'
    ['blue']='#[fg=yellow,bg=black]'
    ['default']='#[default]'
  )

  for option in $@; do
    case ${option} in
      '-n'|'--color-name' )
        [[ -z $2 || $2 =~ ^-+ ]] && return 1
        local color=${colors[$2]}
        shift 2
      ;;
      '-c'|'--color-code' )
        [[ -z $2 || $2 =~ ^-+ ]] && return 1
        local color=$2
        shift 2
      ;;
      '-s'|'--string' )
        # -30dBm
        [[ -z $2 ]] && return 1
        local string=$2
        shift 2
      ;;
    esac
  done

  echo "${color} ${string}${colors['default']}"
}

# メモリ使用量
function memory() {
  local src
  src=$(free -h | sed '/^Mem:/!d;s/  */ /g' | cut -d' ' -f3)
  echo "$(separator 'blue')#[fg=black,bg=yellow]memory:$(output -n 'black' -s ${src})"
}

# ロードアベレージ
function load_average() {
  local src cpus
  src=$(uptime | sed -E 's/.*load average: ([0-9]\.[0-9][0-9]).*/\1/g')
  cpus=$(grep 'processor' /proc/cpuinfo | wc -l)
  echo "$(separator 'black')cpu:$(output -n 'blue' -s ${src}/${cpus})"
}

# 電波強度
function network_level() {
  local -r interface='wlp4s0'

  [[ -n $(ip link show up dev ${interface}) ]] \
    && local -r signal=$(cat /proc/net/wireless \
      | tail -1 | tr -s ' ' | cut -d' ' -f4 | sed 's/\./dBm/') \
    || local -r signal='---'

  echo "$(separator 'blue')#[fg=black,bg=yellow]network:$(output -n 'black' -s ${signal})"
}

# 音量
function sound() {
  function get_volume() {
    local volume
    volume="$(pactl list sinks \
      | grep 'Volume' | grep -o '[0-9]*%' | head -1 | tr -d '%')"
    [[ ${volume} -gt 100 ]] && echo 100 || echo "${volume}"
  }

  function get_muted() {
    pactl list sinks \
      | grep 'Mute' | sed 's/[[:space:]]//g' | cut -d: -f2 | head -1
  }

  function to_blocks() {
    seq -f '%02g' -s '' 1 5 $1 | sed 's/.\{2\}/■/g'
  }

  function to_spaces() {
    seq -s '_' $1 5 100 | tr -d '[:digit:]'
  }

  function to_meters() {
    echo "[$(to_blocks $1)$(to_spaces $1)]"
  }

  type pactl &> /dev/null \
    || { echo "$(sep 'black')$(value 'blue' '×') "; return 1; }

  local -rA colors=(
    ['yes']='#[fg=colour237,bg=black]'
    ['no']='blue'
  )
  local -rA options=(
    ['yes']='--color-code'
    ['no']='--color-name'
  )
  local muted
  muted=$(get_muted)

  echo "$(separator 'black')volume:$(output \
      ${options[${muted}]} ${colors[${muted}]} \
      -s $(to_meters $(get_volume)))" \
      | sed 's/_/ /g'
}

# 時刻
function hours_minutes() {
  echo "$(separator 'blue')$(output -n 'black' -s $(date +%H:%M))"
}

# バッテリー残量
function battery() {
  function online() {
    [[ $(cat /sys/class/power_supply/ADP1/online) != '1' ]] \
      && return
    local -ar icons=('' '' '' '' '')
    local index
    index=$(expr $(date +%S) % ${#icons[@]})
    output -n 'blue' -s ${icons[${index}]}
  }

  [[ -e '/sys/class/power_supply/BAT1' ]] \
    || { echo "$(separator 'black')$(online)"; return; }

  local charge
  charge=$(< /sys/class/power_supply/BAT1/capacity)

  if [[ ${charge} -gt 79 ]];then
    local -r color='#[fg=#08d137,bg=black]'
  elif [[ ${charge} -gt 20 ]];then
    local -r color='#[fg=#509de0,bg=black]'
  else
    local -r color='#[fg=#f73525,bg=black]'
  fi

  echo "$(separator 'black')battery:$(online) $(output -c ${color} -s ${charge}%)"
}

function main() {
  if [[ $1 == 'short' ]];then
    echo -n "$(memory)$(load_average)"
  else
    echo -n "$(memory)$(load_average)$(network_level)$(sound)$(hours_minutes)$(battery)"
  fi
  echo '  '
}

main ${1:-long}
