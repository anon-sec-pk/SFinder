![Screenshot](Screenshot%202025-10-01%20013510.png)
# SFinder - Subdomain Discovery Tool

A powerful bash script for comprehensive subdomain enumeration using multiple reconnaissance tools.

##  Features

- Multi-tool integration (subfinder, findomain, assetfinder, subdominator, crt.sh)
- Live subdomain detection with httpxI
- Duplicate removal and sorting

##  Requirements

```bash
# Required Tools
subfinder, findomain, assetfinder, subdominator, httpx, jq
```

##  Installation

```bash
git clone https://github.com/Zeeshan1337/sfinder.git
cd sfinder
chmod +x sfinder.sh
```

##  Usage

```bash
# Basic usage
./sfinder.sh example.com

# With output directory
./sfinder.sh example.com -o /path/to/output

# Show help
./sfinder.sh -h
```

##  Output Files

- `subfinder.txt` - Subfinder results
- `findomain.txt` - Findomain results  
- `assetfinder.txt` - Assetfinder results
- `subdominator.txt` - Subdominator results
- `crtsh.txt` - crt.sh results
- `all_subdomains.txt` - All unique subdomains
- `live_subdomains.txt` - Live subdomains

##  Example

```bash
./sfinder.sh target.com
```


---
*Use responsibly and only on authorized domains.*
