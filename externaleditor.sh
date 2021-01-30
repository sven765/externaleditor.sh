#!/bin/bash

# A bash script to copy the contents of the active editing area of an
# application into an external editor and back. For example, use it to
# edit Thunderbird email messages in your favorite editor.

# Copyright (c) 2020-2021 Sven Hartenstein
# This script is released under the MIT License.
# It's home is https://github.com/sven765/externaleditor.sh


# Requirements:
# - X server must be running.
# - xclip and xdotool need to be installed.
# - This script must be run via keyboard shortcut while the window,
#   the contents of which you want to edit, is active (has focus).
#   That is, you need to configure a keyboard shortcut in your window
#   manager.

# Configuration:

# The external editor you want to use.
externaleditor="emacsclient" # This assumes that Emacs is running as a server (see Emacs' function "server-start"). In Emacs, press C-x # when finished editing.
# externaleditor="gvim -f" # if you want to use gvim
# externaleditor="gnome-terminal -- vim" # if you want to use vim inside a gnome-terminal
# externaleditor="emacs" # if you want to open a new Emacs instance

# A character string which is part of the window title of your email
# client. If this string is found in the window title, the file that
# is send to the external editor gets the extension ".eml" (otherwise
# ".txt"). (This may or may not be important to you.)
emailclientwindowtitle="Thunderbird"

# End of configuration. The script is annotated to make it easier to
# adapt it.

# Note: This script is rather simple and stupid, using "select all",
# "copy", and "paste" by "pressing" keyboard shortcuts
# programmatically. This is not immune to errors. For example, if you
# send the body of an email message to the external editor and put the
# cursor into the "To" field of the email client before finishing the
# edit, the script can not find the message body and should surely not
# paste the edited text into the "To" field. As a small measure
# against such problems, this scripts inserts a check string into the
# application window which is active when the script is run, and later
# checks if it can still find this check string. If it does not, or
# the original window does not exist anymore, a short and informative
# popup message is displayed.


## Check for dependencies
deps=(xclip xdotool)
depsaremissing=0
for dep in "${deps[@]}"; do
    if [ -z "$(which "${dep}")" ]; then
	xmessage -buttons Okay:0 -default Okay -center "Missing dependency! Please install ${dep}."
	depsaremissing=1
    fi
done
if [ "1" == "${depsaremissing}" ]; then
    exit 1
fi

windowid=$(xdotool getactivewindow) # get ID of active window
windowname=$(xdotool getwindowname ${windowid}) # get name of active window
## Guess whether editing an email and use apropriate filename
## extension.
if [[ "${windowname}" == *"${emailclientwindowtitle}"* ]]; then
    tmpfile="/tmp/externaleditor-${windowid}.eml"
else
    tmpfile="/tmp/externaleditor-${windowid}.txt"
fi
sleep 0.6 # wait and hope that the key press is finished before continuing
xclip -i /dev/null # clear clipboard to prevent pasting the previous contents in the case where there's no source data to copy
xdotool key ctrl+a # select all
xdotool key ctrl+c # copy selection to clipboard
xdotool key Up # place cursor at beginning of text
xdotool type -delay 0 "_!ExternalEditorIsEditingThis!_" # write into window for later check
xclip -o > "${tmpfile}" # write clipboard to temporary file
${externaleditor} "${tmpfile}" # open file in editor (and wait until finished)
if xdotool windowfocus "${windowid}" 2>/dev/null; then # only if the original window can get focus
    xdotool key ctrl+a # select all
    xdotool key ctrl+c # copy selection to clipboard for the following check
    if [[ "$(xclip -o)" == "_!ExternalEditorIsEditingThis!_"* ]]; then # only if the clipboard content starts with the check string
	xclip -i -selection c < "${tmpfile}" # copy file to clipboard
	xdotool key ctrl+v # insert clipboard into window
	xdotool key Prior # scroll up
	xdotool key Prior # scroll up
	xdotool key Prior # scroll up
	xdotool key Prior # scroll up
	xdotool key Prior # scroll up
	xdotool windowactivate "${windowid}" # raise window
	[ -f "${tmpfile}" ] && rm "${tmpfilef}" # remove temporary file
    else
	xclip -i -selection c < "${tmpfile}" # copy file to clipboard
	mv ${tmpfile} "${tmpfile}_saved" # save the tmpfile
	echo -e "Oops! I could not find the check phrase in the text of the window.\nMaybe the cursor was placed somewhere else or the text was changed.\nI therefore do not insert the edited text there but copy it to the\nclipboard (so that you can manually paste it). I also do not delete\nthe temporary file ${tmpfile}_saved." | xmessage -buttons Okay:0 -default Okay -center -file - # inform the user
    fi
else
    xclip -i -selection c < "${tmpfile}" # copy file to clipboard
    mv ${tmpfile} "${tmpfile}_saved" # save the tmpfile
    echo -e "Oops! I could not find the original window the contents of which was\nsent to the external editor. I therefore do not insert the edited text\nanywhere but copy it to the clipboard (so that you can manually paste\nit). I also do not delete the temporary file ${tmpfile}_saved." | xmessage -buttons Okay:0 -default Okay -center -file - # inform the user
fi
