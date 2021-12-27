#!/bin/bash
if [[ $# -lt 1 ]] ; then
    echo "Usage: ./hardlinks.sh <fileOrDirToFindFor> ..."
    exit 1
fi

while [[ $# -ge 1 ]] ; do
    echo "Processing '$1'"
    if [[ ! -r "$1" ]] ; then
        echo "   '$1' is not accessible"
    else
        numlinks=$(ls -ld "$1" | awk '{print $2}')
        inode=$(ls -id "$1" | awk '{print $1}' | head -1l)
        device=$(df "$1" | tail -1l | awk '{print $6}')
        echo "   '$1' has inode ${inode} on mount point '${device}'"
        find ${device} -inum ${inode} 2>/dev/null | sed 's/^/        /'
    fi
    shift
done
