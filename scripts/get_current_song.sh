#!/usr/bin/env bash

if [ $(pidof spotify | wc -l) -eq 0 ]
then
	exit 0
fi

META=$( dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata')

ARTIST=$( echo "$META" | grep -m 1 "xesam:artist" -b2 | tail -n1 | grep -o '".*"' | sed 's/"//g' ) 

SONG_TITLE=$( echo "$META" | grep -m 1 "xesam:title" -b1 | tail -n1 | grep -o '".*"' | sed 's/"//g' )

PLAYING=$( dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' | grep -o Playing )

GREEN='#[fg=colour34]'
DEFAULT='#[default]'

if [ "$PLAYING" ]
then
	ICON="♫"
else
	ICON="⏸"
fi

printf "${GREEN}$ICON${DEFAULT} $ARTIST - $SONG_TITLE"
