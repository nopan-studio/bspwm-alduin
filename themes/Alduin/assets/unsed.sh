#!/bin/sh
sed -i \
         -e 's/rgb(0%,0%,0%)/#171717/g' \
         -e 's/rgb(100%,100%,100%)/#dfdfaf/g' \
    -e 's/rgb(50%,0%,0%)/#171717/g' \
     -e 's/rgb(0%,50%,0%)/#af5f5f/g' \
 -e 's/rgb(0%,50.196078%,0%)/#af5f5f/g' \
     -e 's/rgb(50%,0%,50%)/#171717/g' \
 -e 's/rgb(50.196078%,0%,50.196078%)/#171717/g' \
     -e 's/rgb(0%,0%,50%)/#dfdfaf/g' \
	"$@"
