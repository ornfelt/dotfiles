#!/usr/bin/env bash
case $1 in
	"1") $2 -e bash -c 'nvim ~/Documents/notes.txt;' ;;
	"2") $2 -e bash -c 'nvim ~/Documents/help.txt;' ;;
esac

