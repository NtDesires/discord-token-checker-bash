if [ $# -ne 1 ]; then

echo "Использование: $0 <директория>"

exit 1

fi

# Установить путь к директории

dir="$1"

outdir=$dir"/Sorter"

# Установить выходной файл

outfile=$outdir"/ds-tokens.txt"

mkdir -p "$outdir"

# Функция для рекурсивного обхода

function traverse_dir() {

# Перебрать файлы и папки в текущей директории

for file in "$1"/*; do

# Если это файл Pola*.txt

if [[ "$file" =~ Discord.*\.txt$ ]]; then

# Добавить каждую строку в выходной файл

while read line; do

echo "$line" >> "$outfile"

done < "$file"

# Если это папка, рекурсивно вызвать функцию

elif [ -d "$file" ]; then

traverse_dir "$file"

fi

done

}

# Вызвать функцию для начальной директории

traverse_dir "$dir"

echo "Объединил строки из файлов discord*.txt в $dir в $outfile"
