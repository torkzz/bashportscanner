#!/bin/bash
# Full bash port scanner 

# Usage function
usage() {
    echo "Usage: $0 IP [-F]"
    echo "Options:"
    echo "  -F   Fast scan"
    exit 1
}

# Check for required argument
if [ -z "$1" ]; then
    usage
fi

ip=$1

# Define common ports for fast scan
fast=(7 9 13 21 22 23 25 26 37 53 79 80 81 88 106 110 111 113 119 135\
 139 143 144 179 199 389 427 443 444 445 465 513 514 515 543 544 548\
 554 587 631 646 873 990 993 995 1025 1026 1027 1028 1029 1110 1433\
 1720 1723 1755 1900 2000 2001 2049 2121 2717 3000 3128 3306 3389\
 3986 4899 5000 5009 5051 5060 5101 5190 5357 5432 5631 5666 5800\
 5900 6000 6001 6646 7070 8000 8008 8009 8080 8081 8443 8888 9100 9999\
 10000 32768 49152 49157)

# Function to perform port scan
scan() {
    ip=$1
    p=$2
    # Use nc (netcat) for port scanning
    timeout 1 nc -zv "$ip" "$p" &>/dev/null
    # Check the exit status to determine port status
    case $? in
        0)
            echo "Port $p : Open"
            ;;
        1)
            echo "Port $p : Closed"
            ;;
        124)
            echo "Port $p : Timeout"
            ;;
    esac
}

# Perform fast or full scan based on user input
if [ "$2" == "-F" ]; then
    for p in "${fast[@]}"; do
        scan "$ip" "$p"
    done
else
    for p in {1..65535}; do
        scan "$ip" "$p"
    done
fi
