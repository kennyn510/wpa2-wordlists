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
	awk '!(count[$0]++)' "$f_path" > ${f_path}-new
	[ $? -eq 0 ] && { echo "Duplicates have been removed, view new file at ${f_path}-new"; exit 0; }
	;;
	2) read -p "Enter path to file: " f_path
	awk '{print length, $0}' "$f_path" | sort -n | cut -d " " -f2- > ${f_path}-new
	[ $? -eq 0 ] && { echo "File has been sorted by length at ${f_path}-new"; exit 0; }
	;;
	3) read -p "Enter path to file: " f_path
	sort "$f_path" | uniq > ${f_path}-new
	[ $? -eq 0 ] && { echo "File has been sorted by alphabetical order at ${f_path}-new"; exit 0; }
	;;
	4) read -p "Enter path to file: " f_path
	egrep -v "^[[:space:]]*$" "$f_path" > ${f_path}-new
	[ $? -eq 0 ] && { echo "File has been removed of all blank lines at ${f_path}-new"; exit 0; }
	;;
	q) echo "Peace"
	;;
	*) echo "I do not understand"
	;;
esac

# Remove duplicates
#awk '!(count[$0]++)' old.txt > new.txt

# Sort by length
#awk '{print length, $0}' old.txt | sort -n | cut -d " " -f2- > new.txt

# Sort by alphabetical order
#sort old.txt | uniq > new.txt

# Remove all blank lines
#egrep -v "^[[:space:]]*$" old.txt > new.txt
