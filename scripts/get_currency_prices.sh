#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$CURRENT_DIR/helpers.sh"

CACHE_FILE="$CURRENT_DIR/.currency_cache"
CACHE_TIME_FILE="$CURRENT_DIR/.currency_cache_time"
ERROR_FILE="$CURRENT_DIR/.error"

UPDATE_INTERVAL=$(get_tmux_option "@tmux-currency-update-interval")
UPDATE_INTERVAL=${UPDATE_INTERVAL:-60}

CURRENCIES=$(get_tmux_option "@tmux-currency-currencies" "USD-BRL")

format_bid() {
  local value="$1"
  if [[ "$value" == *"."* ]]; then
    printf "%.2f" "$value"
  else
    echo "$value"
  fi
}

fetch_prices() {
  if [[ -f "$CACHE_TIME_FILE" ]]; then
    local last_cache_time=$(cat "$CACHE_TIME_FILE")
    local current_time=$(date +%s)
    if ((current_time - last_cache_time < UPDATE_INTERVAL)); then
      cat "$CACHE_FILE"
      return
    fi
  fi
  response=$(curl -s "https://economia.awesomeapi.com.br/json/last/$CURRENCIES")

  if echo "$response" | jq -e 'has("status")' >/dev/null 2>&1; then
    echo "Error"
    echo "$response" >"$ERROR_FILE"
    return 1
  fi

  echo "$response" >"$CACHE_FILE"
  echo $(date +%s) >"$CACHE_TIME_FILE"
  echo "$response"
}

get_currency_prices() {
  local json_data=$(fetch_prices)
  local output=""

  if echo "$json_data" | grep -q "Error"; then
    echo "Currency: Error!"
    exit 1
  fi

  for currency in ${CURRENCIES//,/ }; do
    key=$(echo "$currency" | tr -d '-' | tr 'a-z' 'A-Z')
    code=$(echo "$json_data" | jq -r ".${key}.code")
    bid=$(echo "$json_data" | jq -r ".${key}.bid")
    if [[ "$code" == "null" || "$bid" == "null" ]]; then
      continue
    fi

    formatted_bid=$(format_bid "$bid")
    icon="$(get_icon $code)"
    output+="$code: $icon $formatted_bid | "
  done
  echo "${output% | }"
}

get_currency_prices
