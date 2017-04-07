ob-pass-menu
============

Openbox pipe-menu script that generates an xml menu based on zx2c4-pass storage.


Installation
------------

* Place this script in ~/.config/openbox

* Make it executable
`$ chmod +x pass-menu.sh`

* Edit ~/.config/openbox/menu.xml to insert the line:
`<menu id="pass" label='_Passwords' execute='~/.config/openbox/pass-menu.sh' />`

* Tell openbox of your changes by doing
`$ openbox --reconfigure`


Links
-----

*[Pass: The Standard Unix Password Manager](https://www.passwordstore.org/)
*[Openbox menus documentation](http://openbox.org/wiki/Help:Menus#Pipe_menus)
