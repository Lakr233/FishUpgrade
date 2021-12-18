#!/bin/sh

check_dnd_status() {
    DND_STATUS=$(plutil -extract dnd_prefs xml1 -o - "$HOME"/Library/Preferences/com.apple.ncprefs.plist | xmllint --xpath "string(//data)" - | base64 --decode | plutil -convert xml1 - -o - | xmllint --xpath 'boolean(//key[text()="userPref"]/following-sibling::dict/key[text()="enabled"])' -)
}
check_dnd_status
echo $DND_STATUS
