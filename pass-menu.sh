#!/usr/bin/env bash

PREFIX="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
PS_PATH="$1"

#~ TYPE_CMD='xvkbd -file - 2>/dev/null'
TYPE_CMD='xdotool type --clearmodifiers --file -'

TPL_DIR_MENU="<menu id='pass-%s' label='%s' execute='$0 %q' />\n"
TPL_FILE_MENU="<item label='Type _password'>
	<action name='Execute'><command>
		sh -c 'pass show -- %q | $TYPE_CMD'
	</command></action>
</item>
<item label='Type _login and password'>
	<action name='Execute'><command>
		sh -c '(echo -ne %q ; pass show -- %q) | $TYPE_CMD'
	</command></action>
</item>
<item label='_Copy password to clipboard'>
	<action name='Execute'><command>
		pass show -c -- %q ;
	</command></action>
</item>\n"


echo '<?xml version="1.0" encoding="UTF-8"?><openbox_pipe_menu>'

if [ -d "$PREFIX/$PS_PATH" ] ; then
	cd -- "$PREFIX/$PS_PATH"
	[ "$PS_PATH" ] && PS_PATH="$PS_PATH/"
	for item in * ; do
		printf "$TPL_DIR_MENU" "${PS_PATH}${item}" "${item%.gpg}" "${PS_PATH}${item}"
	done
else
	PS_NAME="${PS_PATH%.gpg}"
	LABEL="${PS_NAME##*/}"
	printf "$TPL_FILE_MENU" "$PS_NAME" "$LABEL\t" "$PS_NAME" "$PS_NAME"
fi

echo '</openbox_pipe_menu>'
