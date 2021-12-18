#!/bin/sh

enable_dnd() {
    defaults read "$HOME"/Library/Preferences/com.apple.ncprefs.plist >/dev/null
    DND_HEX_DATA=$(plutil -extract dnd_prefs xml1 -o - "$HOME"/Library/Preferences/com.apple.ncprefs.plist | xmllint --xpath "string(//data)" - | base64 --decode | plutil -convert xml1 - -o - | plutil -insert userPref -xml "
    <dict>
        <key>date</key>
        <date>$(date -u +"%Y-%m-%dT%H:%M:%SZ")</date>
        <key>enabled</key>
        <true/>
        <key>reason</key>
        <integer>1</integer>
    </dict> " - -o - | plutil -convert binary1 - -o - | xxd -p | tr -d '\n')
    defaults write com.apple.ncprefs.plist dnd_prefs -data "$DND_HEX_DATA"
    PROCESS_LIST=(
    #cfprefsd
    usernoted
    #NotificationCenter
    )
    while IFS= read -r line || [[ -n "$line" ]] 
	do
	if [[ "$line" == "" ]]; then continue; fi
        i="$line"
        #echo "$i"
        if [[ $(ps aux | grep "$i" | grep -v grep | awk '{print $2;}') != "" ]]
        then
        	killall "$i" && sleep 0.1 && while [[ $(ps aux | grep "$i" | grep -v grep | awk '{print $2;}') == "" ]]; do sleep 0.5; done
	else
		:
	fi
    done <<< "$(printf "%s\n" "${PROCESS_LIST[@]}")"
    #sleep 2
}
enable_dnd
