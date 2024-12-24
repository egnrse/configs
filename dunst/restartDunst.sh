#/bin/bash

# restart and test dunst
# (by egnrse)
#
# restarts dunst and sends custom notifications

killall dunst
sleep 0.5
dunst &

# send notifications
sleep 0.5

notify-send -u normal -a "custom app" "notify header" "this is a random body with a bit of test text"
sleep 0.2
notify-send -u normal "summary" "first line \n and a new line."
sleep 1
notify-send -u critical "very important" "well actually not, but whatever..."
sleep 0.2
notify-send -u normal "summary" "first line \n and a new line."
notify-send -u low "not important" " ! :) # $  some special characters"
sleep 0.2
notify-send -u normal "not important (again)" "https://dunst-project.org/"
sleep 1
notify-send -u normal "summary" "first line \n and a new line."
sleep 1
notify-send -u normal "empty body" ""
#sleep 0.2
# TODO: use dunstify and actions
#notify-send -u normal "empty body" ""

