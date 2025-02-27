#!/usr/bin/env bash

PATH="/usr/local/bin:$PATH:/usr/sbin"

get_icon() {
  case "$1" in
  USD) echo "💵" ;;
  BTC) echo "₿" ;;
  EUR) echo "💶" ;;
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
