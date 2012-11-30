# VirtualCandy
# Use at your own risk, no quarentee provided.
# Author: Jeff Buttars
# git@github.com:jeffbuttars/virtualcandy.git
# See the README.md

# Source in the common code first, override
# what's necessary

THIS_DIR=$(readlink -f "$(dirname $0)")
source "$THIS_DIR/vc_common_code.sh"


VC_VCTAGS_PID=''
function _vcexit()
{
    echo "$VC_VCTAGS_PID" > /tmp/lastvctags.pid
    if [[ "$VC_VCTAGS_PID" != '' ]]
    then
        echo "Cleaning up vctags $VC_VCTAGS_PID"
        kill $VC_VCTAGS_PID
        wait $VC_VCTAGS_PID
    fi
    
} #_vcexit

# TRAPINT() {
#     _vcexit
# }


function vcfinddir()
{
    _vcfinddir
} #vcfinddir

# Start a new virtualenv, or 
# rebuild on from a requirements.txt file.
function vcstart()
{
    _vcstart $@
} #vcstart

# A simple, and generic, pip update script.
# For a given file containing a pkg lising
# all packages are updated. If no args are given,
# then a 'requirements.txt' file will be looked
# for in the current directory. If the $VC_DEFUALT_VENV_REQFILE
# variable is set, than that filename will be looked
# for in the current directory.
# If an argument is passed to the function, then
# that file and path will be used.
# This function is used by the vcpkgup function
function pip_update()
{
 _pip_update $@
} #pip_update

# Upgrade the nearest virtualenv packages
# and re-freeze them
function vcpkgup()
{
    _vcpkgup $@
} #vcpkgup


function vcfindenv()
{
    _vcfindenv $@
} #vcfindenv

function vcfreeze()
{
    _vcfreeze $@
} #vcfreeze

function vcactivate()
{
    _vcactivate $@
} #vcactivate
alias -g vca='vcactivate'

function _vctags()
{
    # vloc=$(vcfindenv)
    vdir=$(vcfinddir)
    filelist="$vdir/"

    touch $vdir/tags
    ccmd="ctags --sort=yes --tag-relative=no -R --python-kinds=-i -o $vdir/tags"

    if [[ "$#" != "0" ]]; then
        filelist="$filelist $@"
    fi

    ccmd="$ccmd $filelist"
    echo "Using command '$ccmd'"
    eval $ccmd

    res=$(which inotifywait)
    VC_AUTOTAG_RUN=1
    if [[ -n $res ]]; then
        while [[ "$VC_AUTOTAG_RUN" == "1" ]]; do
            inotifywait -e modify -r $filelist
            nice -n 19 ionice -c 3 $ccmd
            # Sleep a bit to keep from hitting the disk
            # to hard during a mad editing burst from 
            # those mad men coders
            sleep 30
        done
    fi
} #_vctags

function vctags()
{
    # _vctags
    _vctags 1>/dev/null 2>&1 &
    VC_VCTAGS_PID="$!"
    echo "vctags: $VC_VCTAGS_PID"
} #vctags


function vcbundle()
{
    _vcbundle $@
} #vcbundle

function vcmod()
{
    _vcmod $@
} #vcmod

function vc_auto_activate()
{
    _vc_auto_activate $@
} #vc_auto_activate

# chpwd_functions=(${chpwd_functions[@]} "vc_auto_activate")
# Automatically activate the current directories
# Virtualenv is one exists
if [[ "$VC_AUTO_ACTIVATION" == "true" ]]; then
    chpwd_functions=(${chpwd_functions[@]} "vc_auto_activate")
    # We want to run it now in case the terminal was started
    # with CWD in a virtuanenv directory
    vc_auto_activate
fi

zshexit_functions=(${zshexit_functions[@]} "_vc_exit")

# vim:set ft=zsh:
