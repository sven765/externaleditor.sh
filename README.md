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

Set the external editor you want to use and some info about your email
client in the bash script.

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

I started writing this script because the [External Editor plugin for
thunderbird](https://github.com/exteditor/exteditor/) no longer worked
with newer versions of thunderbird.

## Thanks

Thanks to [@ebardie](https://github.com/ebardie) for [several
improvements](https://github.com/exteditor/exteditor/issues/74#issuecomment-765333628)!

## Copyright and license

Copyright (c) 2020-2021 Sven Hartenstein

The script is released under the [MIT
License](https://github.com/sven765/externaleditor.sh/blob/main/LICENSE).

## Contributing

If you have suggestions on how to improve this script, please file an
[issue](https://github.com/sven765/externaleditor.sh/issues) or make a
[pull request](https://github.com/sven765/externaleditor.sh/pulls).

