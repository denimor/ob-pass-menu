#!/usr/bin/env bash

PREFIX="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
PS_DIR=''

[ -n "${1}" ] && PS_DIR="${1}/"

#~ TYPE_CMD='xvkbd -file - 2>/dev/null'
TYPE_CMD='xdotool type --clearmodifiers --file -'

TPL_DIR_MENU="<menu id='pass-%s' label='%s' execute='${0} \"${PS_DIR}%s\"' />\n"
TPL_FILE_MENU="<menu id='pass-%s' label='%s'>
	<item label='Type _password'>
		<action name='Execute'><command>
			sh -c 'pass show -- %q | ${TYPE_CMD}'
		</command></action>
	</item>
	<item label='Type _login and password'>
		<action name='Execute'><command>
			sh -c '(echo -ne %q ; pass show -- %q) | ${TYPE_CMD}'
		</command></action>
	</item>
	<item label='_Copy password to clipboard'>
		<action name='Execute'><command>
			pass show -c -- %q ;
		</command></action>
	</item>
</menu>\n"


echo '<?xml version="1.0" encoding="UTF-8"?><openbox_pipe_menu>'

cd -- "${PREFIX}/${PS_DIR}"
for item in * ; do
	if [ -d "${item}" ] ; then
		printf "${TPL_DIR_MENU}" "${item}" "${item}" "${item}"
	elif [ -f "${item}" ] ; then
		LABEL=${item%%.gpg}
		PS_NAME="${PS_DIR}${LABEL}"
		printf "${TPL_FILE_MENU}" "${LABEL}" "${LABEL}" "${PS_NAME}" "${LABEL}\t" "${PS_NAME}" "${PS_NAME}"
	fi
done

echo '</openbox_pipe_menu>'
