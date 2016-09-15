#!/bin/bash

set -e
#set -x

function usage {
    echo "Usage:   $0 [PATH TO REPO] [ARCHIVE PREFIX] [VERSION] [ARCH] [STDLIB]"
    echo "Example: $0 ./cntrinfod cntrinfod 0.2.0 x64 libmusl"
    exit 1
}

if [ "$#" -ne 5 ]; then
	usage
fi

REPO_DIR="$1"
ARCHIVE_NAME="$2"
VERSION="$3"
ARCH="$4"
STDLIB="$5"

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source $SCRIPT_DIR/common.sh

RELENG_DIR=$REPO_DIR/releng
cd "$REPO_DIR"
echo "Changed current working dir to $(pwd)"

panic_if_working_copy_is_dirty

execute 'git checkout v$VERSION'
execute 'go test'
execute 'go build'

cd "$RELENG_DIR"
echo "Changed current working dir to $(pwd)"

ARCHIVE_ROOT="tmp"

if [ -d "$ARCHIVE_ROOT" ]; then
  rm -rf "$ARCHIVE_ROOT"
fi

mkdir "$ARCHIVE_ROOT"

#####
# Now call the project specific script which
# is responsible to assemble the artifact.
#
mkdir -p "$ARCHIVE_ROOT/usr/local/bin"
mkdir -p "$ARCHIVE_ROOT/usr/local/etc/cntrinfod"
mkdir -p "$ARCHIVE_ROOT/usr/local/share/cntrinfod"

cp ../cntrinfod "$ARCHIVE_ROOT/usr/local/bin"
cp -r ../static_data/* "$ARCHIVE_ROOT/usr/local/share/cntrinfod"

#
#####

ARCHIVE="$ARCHIVE_NAME-v$VERSION-$ARCH-$STDLIB.tar.gz"
tar -czf "$ARCHIVE" -C "$ARCHIVE_ROOT" usr

cat << EOF
************************************************************
* $ARCHIVE successfully created:
*

$(tar -tvzf "$ARCHIVE")

*
************************************************************
EOF
