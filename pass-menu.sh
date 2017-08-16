#!/usr/bin/env bash

escape() {
	local s=${1//\&/&amp;}
	s=${s//\'/&apos;}
	s=${s//_/__}
	echo "$s"
}

gen_xml() {
	local PREFIX="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
	local PS_PATH=$(base64 -d <<< "$1")
	local MENU_ID LABEL OPT

	echo '<?xml version="1.0" encoding="UTF-8"?><openbox_pipe_menu>'

	if [[ -d $PREFIX/$PS_PATH ]] ; then
		cd -- "$PREFIX/$PS_PATH"
		[[ $PS_PATH ]] && PS_PATH="$PS_PATH/"
		for item in * ; do
			LABEL=${item%.gpg}
			OPT=$(echo -n "${PS_PATH}${LABEL}" | base64 -w 0)
			LABEL=$(escape "$LABEL")
			echo "<menu id='$OPT' label='$LABEL' execute='$0 $OPT' />"
		done
	else
		printf "<item label='%s'><action name='Execute'><command>$0 %s $1</command></action></item>\n" \
			'Type _password' type \
			'Type _login and password' type_ex \
			'Copy password to _clipboard' clip
	fi

	echo '</openbox_pipe_menu>'
}

type_pass() {
	if type xvkbd >/dev/null ; then
		echo -n "$1" | xvkbd -file - 2>/dev/null
		while [[ $2 ]] ; do
			shift
			xvkbd -text '\t' 2>/dev/null
			echo -n "$1" | xvkbd -file - 2>/dev/null
		done
	else
		IFS='	'
		xdotool type --clearmodifiers "$*"
	fi
}


if [[ $2 ]] ; then
	PS_PATH=$(base64 -d <<< "$2")

	case "$1" in
		   type) type_pass "$(pass show -- "$PS_PATH")" ;;
		type_ex) type_pass "${PS_PATH##*/}" "$(pass show -- "$PS_PATH")" ;;
			clip) pass show -c -- "$PS_PATH" ;;
	esac
else
	gen_xml "$1"
fi
