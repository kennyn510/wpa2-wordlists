#!/bin/bash

echo "What do you want to do?"
echo "1) Remove duplicates "
echo "2) Sort by length "
echo "3) Sort by [0-9][A-Z] "
echo "4) Remove all blank lines "
echo "q) quit "
read -p "> " choice

case $choice in
	1) read -p "Enter path to file: " f_path
	awk '!(count[$0]++)' "$f_path" > new-${f_path}
	echo "Duplicates have been removed, view new file at $PWD/new-$f_path"
	;;
	2) read -p "Enter path to file: " f_path
	awk '{print length, $0}' "$f_path" | sort -n | cut -d " " -f2- > new-${f_path}
	echo "File has been sorted by length at $PWD/new-$f_path"
	;;
	3) read -p "Enter path to file: " f_path
	sort "$f_path" | uniq > new-${f_path}
	echo "File has been sorted by alphabetical order at $PWD/new-$f_path"
	;;
	4) read -p "Enter path to file: " f_path
	egrep -v "^[[:space:]]*$" "$f_path" > new-${f_path}
	echo "File has been removed of all blank lines at $PWD/new-$f_path"
	;;
	q) echo "Peace"
	;;
	*) echo "I do not understand"
	;;
esac
