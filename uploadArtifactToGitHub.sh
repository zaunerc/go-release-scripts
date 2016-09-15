#!/bin/bash

# - See https://developer.github.com/guides/getting-started/ for
#   GitHub API authentication hints.
#
# - See https://developer.github.com/v3/repos/releases/ for 
#   GitHub API doc.
#
# - The tag needs to be present at GitHub before being able
#   to upload a release. Furthermore a formal release has to
#   be created on GitHub.
#   

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

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source $SCRIPT_DIR/common.sh

REPO_NAME="$1"
VERSION="$2"
FILE="$3"
USER="$4"

execute "git push origin v$VERSION"

curl --user $USER \
     --data '{"tag_name":"v$VERSION"}' \
     -H "Content-Type: application/json" \
     "https://api.github.com/repos/$USER/$REPO_NAME/releases"

RELEASE_ID=$(curl -s https://api.github.com/repos/$USER/$REPO_NAME/releases/tags/v$VERSION | jq -r '.id')

curl --user $USER \
     -H "Content-Type: application/gzip" \
     --data-binary @$FILE \
     "https://uploads.github.com/repos/$USER/$REPO_NAME/releases/$RELEASE_ID/assets?name=$(basename $FILE)"

