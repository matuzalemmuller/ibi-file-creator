#!/bin/bash

# Defines path of test folder where files will be created
# if [ -z "$1" ]; then
#     TEST_FOLDER=$HOME/test
# else
#     TEST_FOLDER=$1
# fi

# Defines size of test files in KB
if [ -z "$1" ]; then
    FILE_SIZE=5000
else
    FILE_SIZE=$1
fi

# Defines number of test files created
if [ -z "$2" ]; then
    NUMBER_OF_FILES_CREATED=5
else
    NUMBER_OF_FILES_CREATED=$2
fi

# Defines number of test files to be deleted
if [ -z "$3" ]; then
    NUMBER_OF_FILES_TO_BE_DELETED=1
else
    NUMBER_OF_FILES_TO_BE_DELETED=$3
    if [ $NUMBER_OF_FILES_TO_BE_DELETED -ge $NUMBER_OF_FILES_CREATED ]; then
        echo "Number of files to be deleted is invalid!"
        exit 1
    fi
fi

# Defines number of test files to be modified
if [ -z "$4" ]; then
    NUMBER_OF_FILES_TO_BE_MODIFIED=2
else
    NUMBER_OF_FILES_TO_BE_MODIFIED=$4
    VALID_NUMBER=$(($NUMBER_OF_FILES_CREATED - $NUMBER_OF_FILES_TO_BE_DELETED))
    if [ $NUMBER_OF_FILES_TO_BE_MODIFIED -ge $VALID_NUMBER ]; then
        echo "Number of files to be modified is invalid!"
        exit 1
    fi
fi

# Defines parameters for ibi
IBI_FOLDER="$HOME/Library/Containers/com.ibi.ibiDesktop.ibiDesktopFinderSync/Data/volumes"

if [ -z "$(ls -A $IBI_FOLDER)" ]; then
   echo "No ibi found"
   exit 1
fi

FOLDER="$(df | grep ibi | awk '{$1=$2=$3=$4=$5=$6=$7=$8="";print $0}')/test"

TEST_FOLDER=$(echo $FOLDER | sed -e 's/^[ \t]*//')

# Checks if folder where files will be created exists
# If folder doesn't exist, creates folder
if [ ! -d "$TEST_FOLDER" ]; then
    if [ ! -L "$LINK_OR_DIR" ]; then
        mkdir "$TEST_FOLDER"
    fi
fi

# Creates test files
# Files are named as UUID if uuidgen is avail, otherwise files are named
# using date + random
while [ $NUMBER_OF_FILES_CREATED -gt 0 ]; do
    if [ -z $(command -v uuidgen) ]; then
        DATE=$(date +%s)
        FILENAME="$(($DATE + $RANDOM))$RANDOM"
    else
        FILENAME=$(uuidgen)
    fi

    dd if=/dev/urandom of="$TEST_FOLDER/$FILENAME" bs=1024 count=$FILE_SIZE

    NUMBER_OF_FILES_CREATED=$(($NUMBER_OF_FILES_CREATED-1))
done

# Deletes random files from test folder
while [ $NUMBER_OF_FILES_TO_BE_DELETED -gt 0 ]; do
    NUMBER_OF_FILES_AVAIL=$(ls "$TEST_FOLDER" | wc -l)
    FILES=("$TEST_FOLDER"/*)
    FILE_TO_DELETE="${FILES[$RANDOM % $NUMBER_OF_FILES_AVAIL]}"
    if [[ -d "$FILE_TO_DELETE" ]]; then
        rm -rf "$FILE_TO_DELETE"
    else
        rm "$FILE_TO_DELETE"
    fi
    NUMBER_OF_FILES_TO_BE_DELETED=$(($NUMBER_OF_FILES_TO_BE_DELETED-1))
done

# Modifies random files from test folder
while [ $NUMBER_OF_FILES_TO_BE_MODIFIED -gt 0 ]; do
    NUMBER_OF_FILES_AVAIL=$(ls "$TEST_FOLDER" | wc -l)
    FILES=("$TEST_FOLDER"/*)
    FILE_TO_MODIFY="${FILES[$RANDOM % $NUMBER_OF_FILES_AVAIL]}"
    if [[ -d "$FILE_TO_MODIFY" ]]; then
        continue
    fi
    dd if=/dev/urandom of="$FILE_TO_MODIFY" bs=1024 count=$FILE_SIZE
    NUMBER_OF_FILES_TO_BE_MODIFIED=$(($NUMBER_OF_FILES_TO_BE_MODIFIED-1))
done