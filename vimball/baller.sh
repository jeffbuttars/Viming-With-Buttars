#!/bin/bash
set -e

for f in $(ls -1 *.flist)
do
	vbname=$(basename $f .flist)
	echo ":%MkVimball! $vbname" > vbtmp.vim
	echo ":q" >> vbtmp.vim
	vim -s vbtmp.vim $f
	rm -f vbtmp.vim
done
