#!/bin/bash

# - See https://developer.github.com/guides/getting-started/ for
#   GitHub API authentication hints.
#
# - See https://developer.github.com/v3/repos/releases/ for 
#   GitHub API doc.

set -e
#set -x

function usage {
    echo "Usage: $0 [REPO NAME] [VERSION] [FILE] [GITHUB USERNAME]"
    echo "Example: $0 cntrinfod 0.2.2 releng/cntrinfod-v0.2.2-x64-libmusl.tar.gz zaunerc"
    exit 1
}

if [ "$#" -ne 4 ]; then
	usage
fi

REPO_NAME="$1"
VERSION="$2"
FILE="$3"
USER="$4"

RELEASE_ID=$(curl -s https://api.github.com/repos/zaunerc/$REPO_NAME/releases/tags/v$VERSION | jq -r '.id')

curl -i --user $USER \
     -H "Content-Type: application/gzip" \
     --data-binary @$FILE \
     "https://uploads.github.com/repos/zaunerc/$REPO_NAME/releases/$RELEASE_ID/assets?name=$(basename $FILE)"

