#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/scripts/helpers.sh"

CURRENCY_COMMAND="#($CURRENT_DIR/scripts/get_currency_prices.sh)"

UPDATE_INTERVAL=$(get_tmux_option "@tmux-currency-update-interval")
UPDATE_INTERVAL=${UPDATE_INTERVAL:-60} 

status_key="\#{currency}"

set_tmux_options() {
	local option="$1"
	local value="$2"
	tmux set-option -gp "$option" "$value"
}

do_interpolation() {
	local interpolated="$1"
	interpolated=${interpolated/${status_key}/${CURRENCY_COMMAND}}
	echo "$interpolated"
}

update_tmux_option() {
	local option="$1"
	local option_value="$(get_tmux_option "$option")"
	local new_option_value="$(do_interpolation "$option_value")"
	set_tmux_option "$option" "$new_option_value"
}

main() {
	update_tmux_option "status-right"
	update_tmux_option "status-left"
}

main
