#!/bin/sh


[ -f "$1" ] || { echo "Usage: noweave.sh file" ; exit 1; }

lipsum weave $1 | perl -n -e '/\s*\<\<.*\>\>\=/ || print ' | pandoc -s
