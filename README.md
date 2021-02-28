# externaleditor.sh

A bash script to copy the contents of the active editing area of an
application into an external editor and back. For example, use it to
edit Thunderbird email messages in your favorite editor.

## Requirements

- X server must be running.
- xclip and xdotool need to be installed.
- This script must be run via keyboard shortcut while the window, the
  contents of which you want to edit, is active (has focus). That is,
  you need to configure a keyboard shortcut in your window manager.

## Configuration

Set the following variables in a file called externaleditor.conf in
the same directory as this script! (You can also define them as
environmental variables, e.g. in ~/.profile.) You can copy from the
following examples and uncomment (remove the "#" at the beginning of
the line.

**Variable "externaleditor"**: The external editor you want to
use. Examples:

```
externaleditor="emacsclient" # This assumes that Emacs is running as a server (see Emacs' function "server-start"). In Emacs, press C-x # when finished editing.
externaleditor="gvim -f" # if you want to use gvim
externaleditor="gnome-terminal -- vim" # if you want to use vim inside a gnome-terminal
externaleditor="emacs" # if you want to open a new Emacs instance
```

**Variable "emailclientwindowtitle"**: A character string which is part of
the window title of your email client. If this string is found in the
window title, the file that is send to the external editor gets the
extension ".eml" (otherwise ".txt"). (This may or may not be important
to you.) If the variable is not set, "Thunderbird" is used. Example:

```
emailclientwindowtitle="Thunderbird"
```

**Variable "tbformat"**: Set this to "html" if you compose HTML messages
in Thunderbird in order to preserve line breaks. However, be aware
that HTML formatting is lost when using this script! Unfortunately,
this script is not able to detect the format used in thunderbird, so
there is no good solution for being able to compose both text and HTML
messages without changing this configuration. (You could use two
instances of this script with two different keyboad shortcuts to
invoke them though.) If the variable is not set, "txt" is
used. Example:

```
tbformat="txt"
```

## Note

This script is rather simple and stupid, using "select all", "copy",
and "paste" by "pressing" keyboard shortcuts programmatically. This is
not immune to errors. For example, if you send the body of an email
message to the external editor and put the cursor into the "To" field
of the email client before finishing the edit, the script can not find
the message body and should surely not paste the edited text into the
"To" field. As a small measure against such problems, this scripts
inserts a check string into the application window which is active
when the script is run, and later checks if it can still find this
check string. If it does not, or the original window does not exist
anymore, a short and informative popup message is displayed.

Only pure text is copied and pasted, i.e. formatting is
lost. Therefore, it might not be a good idea to use this script for
formatted Text (like e.g. HTML).

I started writing this script because the [External Editor plugin for
thunderbird](https://github.com/exteditor/exteditor/) no longer worked
with newer versions of thunderbird.

## Thanks

Thanks to [@ebardie](https://github.com/ebardie) for [several
improvements](https://github.com/exteditor/exteditor/issues/74#issuecomment-765333628)!

Thanks to [@dbeniamine](https://github.com/dbeniamine) for suggesting
to separate the configuration from the script!

## Copyright and license

Copyright (c) 2020-2021 Sven Hartenstein

The script is released under the [MIT
License](https://github.com/sven765/externaleditor.sh/blob/main/LICENSE).

## Contributing

If you have suggestions on how to improve this script, please file an
[issue](https://github.com/sven765/externaleditor.sh/issues) or make a
[pull request](https://github.com/sven765/externaleditor.sh/pulls).

