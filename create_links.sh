#!/bin/bash

QUALITY='best[ext=mp4]'
youtube-dl -f $QUALITY -g --get-title $1 > playlist.txt
