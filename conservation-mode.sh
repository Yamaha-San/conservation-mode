#!/bin/bash
name="conservation-mode"
author="Adrian L. F. Batlle Heger"
path="/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"
version="0.2 Alpha"
if [ "$EUID" -ne 0 ]; then
	echo "Please run as root."
	exit
fi
set_mode() {
	echo $1 > $path
}
get_mode() {
	read -r tmp < $path
	return $tmp
}
print_usage() {
	echo "
Usage: $name <option>

Options:
    -v | --version  Shows the version number.
    -h | --help     Shows this text.
    -1 | --on       Turns Conservation Mode on.
    -0 | --off      Turns Conservation Mode off.
    -t | --toggle   Toggles Conservation Mode.
    -s | --status   Shows the current Conservation Mode."
	exit
}
if [ $# -eq 1 ]; then
	case $1 in
		-v | --version)
			echo "
Conservation Mode changer
(C) 2022 $author
Version: $version" ;;
		-h | --help)
			print_usage ;;
		-1 | --on)
			set_mode 1
			echo "Conservation Mode is now on." ;;
		-0 | --off)
			set_mode 0
			echo "Conservation Mode is now off." ;;
		-t | --toggle)
			get_mode
			if [ $? == "0" ]; then
				set_mode 1
				echo "Conservation Mode is now on."
			else
				set_mode 0
				echo "Conservation Mode is now off."
			fi ;;
		-s | --status)
			get_mode
			if [ $? == "0" ]; then
				echo "Conservation Mode is off."
			else
				echo "Conservation Mode is on."
			fi 
			;;
		*)
			print_usage ;;
	esac
else
	print_usage
fi
