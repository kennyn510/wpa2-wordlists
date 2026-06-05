# wpa2-wordlists

A collection of passwords and wordlists commonly used for dictionary attacks against WPA2 and other targets, using tools such as **aircrack-ng**, **hashcat**, **hydra**, and **John the Ripper**.

> ⚠️ **For education and authorized security testing only.** These wordlists are intended for testing networks and systems you own or have explicit written permission to test. Unauthorized access to networks or accounts is illegal under the Computer Fraud and Abuse Act (CFAA) in the US, the Computer Misuse Act in the UK, and equivalent laws worldwide. You are solely responsible for how you use them.

## What's Inside

| Folder | Contents |
|--------|----------|
| `Wordlists/` | Large breach-derived lists, split alphabetically and gzip-compressed (`A.txt.gz`, `B.txt.gz`, …). Sets include Bigone2016, Crackdown2016, Insider2016, Major2016, Neo2016, Potential2016, Ransom2016, Rockyou, and Ultimate2016. |
| `PlainText/` | Smaller, themed lists ready to use as-is — common logins, default router passwords, languages, numeric PINs, and more. |
| `Scripts/` | Helper scripts for sorting and de-duplicating lists. |

> **Note:** These lists were compiled in 2016 from public breach data. They remain effective against weak and reused passwords, but for the newest leaks you may also want to combine them with current sources like RockYou2021/2024 and SecLists.

## How To Use

```bash
# Clone the repo
git clone https://github.com/kennyn510/wpa2-wordlists.git

# Pick a wordlist set and decompress it
cd wpa2-wordlists/Wordlists/Crackdown2016
gunzip *.gz

# Combine the parts into a single file
cat *.txt > full.txt
```

Then point your cracking tool at `full.txt`, for example:

```bash
# Crack a captured WPA2 handshake with aircrack-ng
aircrack-ng handshake.cap -w full.txt

# Or with hashcat (mode 22000 = WPA2)
hashcat -m 22000 -a 0 capture.hc22000 full.txt
```

## Filtering for WPA2 (Important)

WPA2 passwords are **always at least 8 characters**. Any shorter entry can never be a valid WPA2 key and only wastes cracking time. Filter your list to 8+ characters before a WPA2 attack:

```bash
# Keep only passwords 8 characters or longer
awk 'length($0) >= 8' full.txt > wpa2.txt
```

## Useful One-Liners for Wordlist Manipulation

**Remove duplicates (memory-safe for large files)**
```bash
LC_ALL=C sort -u old.txt > new.txt
```
> The classic `awk '!(count[$0]++)'` trick keeps every unique line in RAM and runs out of memory on multi-GB lists. `sort -u` streams to disk and handles huge files — use it instead.

**Sort by length**
```bash
awk '{print length, $0}' old.txt | sort -n | cut -d " " -f2- > new.txt
```

**Sort alphabetically and de-duplicate**
```bash
LC_ALL=C sort old.txt | uniq > new.txt
```

**Merge multiple files into one**
```bash
cat file1.txt file2.txt > combined.txt
```

**Remove all blank lines**
```bash
grep -v '^[[:space:]]*$' old.txt > new.txt
```

## Further Reading

For more on choosing and using wordlists with aircrack-ng, hashcat, and hydra, see this [guide to password wordlists for Kali Linux](https://kennyvn.com/wordlists-password-dictionaries-for-kali-linux/).

## License

Released under [CC0 1.0 Universal](LICENSE) (public domain). Use them however you like.
