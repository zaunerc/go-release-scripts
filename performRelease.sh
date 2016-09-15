#!/bin/bash

set -e
#set -x

function usage {
    echo "Usage: $0 [PATH TO REPO] [RELEASE VERSION] [NEXT DEV VERSION]"
    echo "Example: $0 ./cntrinfod 0.2.1 0.2.2"
    exit 1
}

if [ "$#" -ne 3 ]; then
	usage
fi

REPO_PATH="$1"
VERSION="$2"
NEXT_VERSION="$3-SNAPSHOT"

BINARY=$(basename "$(readlink -f "$REPO_PATH")")

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source $SCRIPT_DIR/common.sh

cd "$REPO_PATH"
echo "Changed current working dir to $(pwd)"

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "master" ]; then
	error_exit "Releases are only suppored on master branch. Aborting!"
fi

panic_if_working_copy_is_dirty

# Update version info
execute 'sed --in-place "s/app.Version = \".*\"/app.Version = \"$VERSION\"/g" $BINARY.go'

cat << EOF

************************************************************
* VERIFY GIT DIFF
*

$(git diff --no-color --unified=0 | cat)

*
************************************************************

************************************************************
* VERIFY GIT USERNAME AND EMAIL
*

Git user name: $(git config --get user.name)
Git email: $(git config --get user.email)

*
************************************************************

The following steps will be executed if you proceed:

1. master> Commit the version number change. New version is $VERSION.
2. master> Create an annotated tag.
3. Checkout branch dev
4. dev> Merge master into dev branch.
5. dev> Update version number to $NEXT_VERSION.
6. dev> Commit the version number change.

EOF

if confirm "Proceed?" -ne 0 ]; then
	git checkout "$BINARY.go"
	exit 0
fi

# master branch

execute 'git commit -a -m "Release version $VERSION."'
execute 'git tag --annotate "v$VERSION" --message "Release of version $VERSION."'

# dev branch

execute 'git checkout dev'
execute 'git merge master'
# Update version info
execute 'sed --in-place "s/app.Version = \".*\"/app.Version = \"$NEXT_VERSION\"/g" $BINARY.go'
execute 'git commit -a -m "Starting development iteration on $NEXT_VERSION."'

cat << EOF

YOU CAN NOW PUSH THE CHANGES TO ORIGIN. EXECUTE:
\$ git push --follow-tags origin master dev

EOF

