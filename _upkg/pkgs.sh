#!/bin/bash

# ENV vars we expect from the pkgs process. If they are not set, we set 
# some defaults and make guesses

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# We assume we're in the pkgs dir, 2 levels deep.
if [[ -z $PKGS_PKG_DIR ]]; then
    PKGS_PKG_DIR="$(dirname $(dirname $THIS_DIR))"
fi

KNRM="\033[0m"
KRED="\033[0;31m"
KGRN="\033[0;32m"
# KYEL="\x1B[33m"
KBLU="\033[0;34m"
# KMAG="\x1B[35m"
# KCYN="\x1B[36m"
# KWHT="\x1B[37m"

pr_pass()
{
    # echo "$1"
    echo -e "${KGRN}$*${KNRM}"
}

pr_fail()
{
    echo -e "${KRED}$*${KNRM}"
}

pr_info()
{
    echo -e "${KBLU}$*${KNRM}"
}
