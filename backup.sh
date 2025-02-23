#!/bin/bash

VERBOSE_OUTPUT=0
ADD_DATE_TO_FILENAME=""

usage() { # usage error
	cat <<EOL
USAGE: $0 [OPTIONS] <source_dir> <backup_name>
OPTIONS:
    -v              : Verbose
    --date <format> : Add date to the backup filename.
                        Supported formats: time, date, datetime, timestamp
EOL
}

if [[ $# -lt 2 ]]; then # chek number of inputs
	usage
	exit 1
fi

while true; do
	case $1 in # check switches
	-v)
		VERBOSE_OUTPUT=1
		shift 1
		;;
	--date)
		case $2 in
		"time")
			ADD_DATE_TO_FILENAME=$(date +%H-%M-%S)
			;;
		"date")
			ADD_DATE_TO_FILENAME=$(date +%Y-%m-%d)
			;;
		"datetime")
			ADD_DATE_TO_FILENAME=$(date +%Y-%m-%d-%H-%M-%S)
			;;
		"timestamp")
			ADD_DATE_TO_FILENAME=$(date +%s)
			;;
		*)
			echo "ERROR: Unsupported date foramt."
			exit 1
			;;
		esac
		shift 2
		;;
	*)
		break
		;;
	esac
done

if [[ $# -ne 2 ]]; then # chekc number of inputs
	usage
	exit 1
fi

if [[ ! -d "$1" ]]; then # check if the backup source is directory or not
	echo "ERROR: $1 should be a directory."
	exit 1
fi

if [[ "$2" != *.tar.gz ]]; then # check the backup name
	echo "ERROR: $2 should be something with .tar.gz extension."
	exit 1
fi

if [[ $VERBOSE_OUTPUT -eq 0 ]]; then # starting backup
	if [[ ADD_DATE_TO_FILENAME == "" ]]; then
		tar -zcf $2 $1 &>/dev/null
	else
		tar -zcf "${ADD_DATE_TO_FILENAME}-${2}" $1 &>/dev/null
	fi
else
	if [[ $VERBOSE_OUTPUT -eq 0 ]]; then
		tar -zvcf $2 $1
	else
		tar -zvcf "${ADD_DATE_TO_FILENAME}-${2}" $1
	fi
fi

if [[ ! -f "$2" ]]; then
	echo "ERROR: Could not create the backup file."
	exit 1
fi

echo "INFO: Backup is created successfully."