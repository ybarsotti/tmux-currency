#!/usr/bin/env bash

PATH="/usr/local/bin:$PATH:/usr/sbin"

get_icon() {
  case "$1" in
  USD) echo "💵" ;;
  EUR) echo "💶" ;;
  GBP) echo "💷" ;;
  JPY) echo "💴" ;;
  CHF) echo "🏦" ;;
  AUD) echo "🦘" ;;
  CAD) echo "🍁" ;;
  CNY) echo "🀄" ;;
  INR) echo "₹" ;;
  BRL) echo "🟢" ;;
  ARS) echo "🪙" ;;
  MXN) echo "🌵" ;;
  RUB) echo "₽" ;;
  ZAR) echo "🦁" ;;
  TRY) echo "₺" ;;
  SEK) echo "🧊" ;;
  NOK) echo "🎿" ;;
  DKK) echo "👑" ;;
  SGD) echo "🦁" ;;
  HKD) echo "🏙️" ;;
  BTC) echo "₿" ;;
  ETH) echo "🟣" ;;
  XRP) echo "⚡" ;;
  LTC) echo "Ł" ;;
  DOGE) echo "🐶" ;;
  SOL) echo "🌞" ;;
  BNB) echo "🟡" ;;
  XAU) echo "🥇" ;;
  XAG) echo "🥈" ;;
  *) echo "💰" ;;
  esac
}

get_tmux_option() {
  local option_name="$1"
  local default_value="$2"
  local option_value=$(tmux show-option -gqv $option_name)

  if [ -z "$option_value" ]; then
    echo -n $default_value
  else
    echo -n $option_value
  fi
}

set_tmux_option() {
  local option_name="$1"
  local option_value="$2"
  $(tmux set-option -gq $option_name "$option_value")
}
