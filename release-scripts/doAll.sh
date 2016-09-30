#!/bin/bash

set -e
#set -x

function usage {
    echo "Usage: $0 [PATH TO REPO] [RELEASE VERSION] [NEXT DEV VERSION] [ARCH] [STDLIB] [GITHUB_USERNAME]"
    echo "Example: $0 ./cntrinfod 0.2.1 0.2.2 x64 libmusl zaunerc"
    exit 1
}

if [ "$#" -ne 6 ]; then
	usage
fi

PATH_TO_REPO=$1
RELEASE_VERSION=$2
NEXT_DEV_VERSION=$3
ARCH=$4
STDLIB=$5
GITHUB_USERNAME=$6

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

##########

PATH_TO_REPO=$1
RELEASE_VERSION=$2
NEXT_DEV_VERSION=$3

echo "Executing performRelease.sh"
$SCRIPT_DIR/performRelease.sh $PATH_TO_REPO $RELEASE_VERSION $NEXT_DEV_VERSION

##########

PATH_TO_REPO=$1
VERSION=$2
ARCH=$4
STDLIB=$5

ARCHIVE_PREFIX=$(basename "$(readlink -f "$1")")

echo "Executing createTarGzPackage.sh"
$SCRIPT_DIR/createTarGzPackage.sh $PATH_TO_REPO $ARCHIVE_PREFIX $VERSION $ARCH $STDLIB

##########

PATH_TO_REPO=$1
REPO_NAME=$(basename "$(readlink -f "$1")")
VERSION=$2
GITHUB_USERNAME=$6

# cntrinfod-v0.2.2-x64-libmusl.tar.gz
FILE="$1/releng/$(basename "$(readlink -f "$1")")-v$2-$ARCH-${STDLIB}.tar.gz"

echo "Executing uploadArtifactToGitHub.sh"
$SCRIPT_DIR/uploadArtifactToGitHub.sh $PATH_TO_REPO $REPO_NAME $VERSION $FILE $GITHUB_USERNAME
