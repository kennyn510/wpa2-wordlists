# wpa2-wordlists

A collection of wordlist/dictionaries used for wpa/wpa2 cracking.

### How To Use:

* git clone https://github.com/kennyn510/wpa2-wordlists.git
* cd wpa2-wordlists
* gunzip *.gz
* cat *.txt >> full.txt

## Useful one-liners for wordlist manipulation
**Remove duplicates**
```
awk '!(count[$0]++)' old.txt > new.txt
```
**Sort by length**
```
awk '{print length, $0}' old.txt | sort -n | cut -d " " -f2- > new.txt
```

**Sort by alphabetical order**
```
sort old.txt | uniq > new.txt
```
**Merge multiple text files into one**
```
cat file1.txt file2.txt > combined.txt
```

**Remove all blank lines**
```
egrep -v "^[[:space:]]*$" old.txt > new.txt
```
