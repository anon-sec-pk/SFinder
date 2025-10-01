#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner Function
show_banner() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║    _____ _______           __                                ║"
    echo "║   / ___// ____(_)___  ____/ /__  _____                      ║"
    echo "║   \__ \/ /_  / / __ \/ __  / _ \/ ___/                      ║"
    echo "║  ___/ / __/ / / / / / /_/ /  __/ /                          ║"
    echo "║ /____/_/   /_/_/ /_/\__,_/\___/_/                           ║"
    echo "║                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                   SFinder Version 1.0                        ║${NC}"
    echo -e "${CYAN}║                   Author: Zeeshan1337                        ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Show required tools
show_required_tools() {
    echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║                     REQUIRED TOOLS                           ║${NC}"
    echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo -e "${CYAN}The following tools must be installed before using SFinder:${NC}"
    echo ""
    echo -e "${GREEN}• subfinder    ${NC}- Subdomain discovery tool"
    echo -e "${GREEN}• findomain    ${NC}- Fast cross-platform subdomain enumerator"
    echo -e "${GREEN}• assetfinder  ${NC}- Find domains and subdomains related to a given domain"
    echo -e "${GREEN}• subdominator ${NC}- Subdomain discovery tool"
    echo -e "${GREEN}• httpx        ${NC}- Fast and multi-purpose HTTP toolkit"
    echo -e "${GREEN}• jq           ${NC}- Command-line JSON processor"
    echo ""
    echo -e "${YELLOW}Installation commands:${NC}"
    echo "go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
    echo "go install -v github.com/findomain/findomain@latest"
    echo "go install -v github.com/tomnomnom/assetfinder@latest"
    echo "go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest"
    echo "sudo apt install jq  # Ubuntu/Debian"
    echo "pipx install subdominator # Ubuntu/Debian"
    echo "brew install jq      # macOS"
    echo ""
}

# Help function
show_help() {
    echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║                         USAGE                                ║${NC}"
    echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}Usage:${NC}"
    echo "  $0 <domain> -o output_directory (optional)"
    echo ""
    echo -e "${GREEN}Examples:${NC}"
    echo "  $0 example.com"
    echo "  $0 example.com -o /home/user/results"
    echo ""
    echo -e "${GREEN}Options:${NC}"
    echo "  -o    Output directory (optional)"
    echo ""
    echo -e "${YELLOW}Note: If no output directory is specified, current directory is used.${NC}"
    echo ""
}

# Show full help with tools and usage
show_full_help() {
    show_banner
    show_required_tools
    show_help
}

# Show minimal usage
show_minimal_usage() {
    echo -e "${YELLOW}Usage: $0 <domain> -o output_directory (optional)${NC}"
    echo -e "${YELLOW}Use -h for help and required tools${NC}"
    echo ""
}

# Check if no arguments provided
if [ $# -eq 0 ]; then
    show_minimal_usage
    exit 1
fi

# Show help if requested
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    show_full_help
    exit 0
fi

# Main execution
show_banner

DOMAIN=$1
OUTPUT_DIR="."

# Parse command line arguments
if [ $# -ge 3 ] && [ "$2" == "-o" ]; then
    OUTPUT_DIR="$3"
    # Check if output directory exists
    if [ ! -d "$OUTPUT_DIR" ]; then
        echo -e "${RED}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${RED}║                         ERROR                               ║${NC}"
        echo -e "${RED}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo -e "${RED}Output directory does not exist: $OUTPUT_DIR${NC}"
        echo -e "${YELLOW}Please create the directory first or use a different path.${NC}"
        exit 1
    fi
fi

echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                     SCAN INFORMATION                         ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo -e "${GREEN}• Target Domain: ${YELLOW}$DOMAIN${NC}"
echo -e "${GREEN}• Output Directory: ${YELLOW}$OUTPUT_DIR${NC}"
echo -e "${GREEN}• Start Time: ${YELLOW}$(date)${NC}"
echo ""

# Progress function
print_progress() {
    echo -e "${BLUE}[*] $1${NC}"
}

print_success() {
    echo -e "${GREEN}[+] $1${NC}"
}

# 1. Subfinder
print_progress "Running Subfinder..."
subfinder -d $DOMAIN -all -silent > "$OUTPUT_DIR/subfinder.txt"
print_success "Subfinder found: $(wc -l < "$OUTPUT_DIR/subfinder.txt" | tr -d ' ') subdomains"

# 2. Findomain
print_progress "Running Findomain..."
findomain -t $DOMAIN --quiet > "$OUTPUT_DIR/findomain.txt"
print_success "Findomain found: $(wc -l < "$OUTPUT_DIR/findomain.txt" | tr -d ' ') subdomains"

# 3. Assetfinder
print_progress "Running Assetfinder..."
assetfinder --subs-only $DOMAIN > "$OUTPUT_DIR/assetfinder.txt"
print_success "Assetfinder found: $(wc -l < "$OUTPUT_DIR/assetfinder.txt" | tr -d ' ') subdomains"

# 4. Subdominator
print_progress "Running Subdominator..."
subdominator -d $DOMAIN > "$OUTPUT_DIR/subdominator.txt" 2>/dev/null
print_success "Subdominator found: $(wc -l < "$OUTPUT_DIR/subdominator.txt" | tr -d ' ') subdomains"

# 5. crt.sh
print_progress "Querying crt.sh..."
curl -s "https://crt.sh/?q=%25.$DOMAIN&output=json" | jq -r '.[].name_value' 2>/dev/null | sed 's/\*\.//g' | sort -u > "$OUTPUT_DIR/crtsh.txt"
print_success "crt.sh found: $(wc -l < "$OUTPUT_DIR/crtsh.txt" | tr -d ' ') subdomains"

# Combine all results
print_progress "Combining and sorting results..."
cat "$OUTPUT_DIR/subfinder.txt" "$OUTPUT_DIR/findomain.txt" "$OUTPUT_DIR/assetfinder.txt" "$OUTPUT_DIR/subdominator.txt" "$OUTPUT_DIR/crtsh.txt" | sort -u > "$OUTPUT_DIR/all_subdomains.txt"

# Remove empty lines and clean up
sed -i '/^$/d' "$OUTPUT_DIR/all_subdomains.txt"

TOTAL_SUBS=$(wc -l < "$OUTPUT_DIR/all_subdomains.txt" | tr -d ' ')
print_success "Total unique subdomains found: $TOTAL_SUBS"

# Run httpx to find live subdomains
print_progress "Checking for live subdomains with httpx..."
httpx -l "$OUTPUT_DIR/all_subdomains.txt" -silent -timeout 10 > "$OUTPUT_DIR/live_subdomains.txt"

LIVE_SUBS=$(wc -l < "$OUTPUT_DIR/live_subdomains.txt" | tr -d ' ')
print_success "Live subdomains found: $LIVE_SUBS"

# Final Summary
echo ""
echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║                     SCAN COMPLETED                           ║${NC}"
echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                         RESULTS                              ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo -e "${GREEN}✓ Domain:${NC} $DOMAIN"
echo -e "${GREEN}✓ Output Directory:${NC} $OUTPUT_DIR"
echo -e "${GREEN}✓ Total Subdomains:${NC} $TOTAL_SUBS"
echo -e "${GREEN}✓ Live Subdomains:${NC} $LIVE_SUBS"
echo -e "${GREEN}✓ Completion Time:${NC} $(date)"
echo ""

echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║                     GENERATED FILES                          ║${NC}"
echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════╝${NC}"
echo -e "${GREEN}• subfinder.txt${NC}       - Subfinder results"
echo -e "${GREEN}• findomain.txt${NC}       - Findomain results"
echo -e "${GREEN}• assetfinder.txt${NC}     - Assetfinder results"
echo -e "${GREEN}• subdominator.txt${NC}    - Subdominator results"
echo -e "${GREEN}• crtsh.txt${NC}           - crt.sh results"
echo -e "${GREEN}• all_subdomains.txt${NC}  - All unique subdomains"
echo -e "${GREEN}• live_subdomains.txt${NC} - Live subdomains"
echo ""

echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                     SFinder v1.0                             ║${NC}"
echo -e "${CYAN}║                     Author: Zeeshan1337                      ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
