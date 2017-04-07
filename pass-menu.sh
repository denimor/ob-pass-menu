#!/usr/bin/env bash

PREFIX="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
PS_DIR=''

if [ -n "${1}" ] ; then
	if [ -f "${PREFIX}/${1}" ] ; then
		PASS_NAME=${1%%.gpg}
		#~ pass show -c -- ${PASS_NAME}
		pass show -- ${PASS_NAME} | xdotool type --clearmodifiers --file -
		exit
	fi
	PS_DIR="${1}/"
fi

TPL_MENU="<menu id='pass-%s' label='%s' execute='${0} \"${PS_DIR}%s\"' />\n";
TPL_MENU_ITEM="<item label='%s'><action name='Execute'><command>${0} \"${PS_DIR}%s\"</command></action></item>\n";

echo '<?xml version="1.0" encoding="UTF-8"?><openbox_pipe_menu>'

cd -- "${PREFIX}/${PS_DIR}"
for item in * ; do
	#~ LABEL=$(basename -s .gpg -- "${item}")
	LABEL=${item%%.gpg}
	if [ -d "${item}" ] ; then
		printf "${TPL_MENU}" "${LABEL}" "${LABEL}" "${item}"
	elif [ -f "${item}" ] ; then
		printf "${TPL_MENU_ITEM}" "${LABEL}" "${item}"
	fi
done

echo '</openbox_pipe_menu>';
