# VirtualCandy
# Use at your own risk, no quarentee provided.
# Author: Jeff Buttars
# git@github.com:jeffbuttars/virtualcandy.git
# See the README.md

# Source in the common code first, override
# what's necessary

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$THIS_DIR/vc_common_code.sh"

function clean_on_exit()
{
    if [[ -n $VC_VCTAGS_PID ]]; then
        kill $VC_VCTAGS_PID
        wait $VC_VCTAGS_PID
    fi
    VC_AUTOTAG_RUN=0
    
} #clean_on_exit

trap "clean_on_exit" EXIT SIGINT SIGHUP SIGKILL SIGTERM

function vcfinddir()
{
    _vcfinddir
} #vcfinddir

# Start a new virtualenv, or 
# rebuild on from a requirements.txt file.
function vcstart()
{
_vcstart
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
    _pip_update
} #pip_update

# Upgrade the nearest virtualenv packages
# and re-freeze them
function vcpkgup()
{
    _vcpkgup
} #vcpkgup


function vcfindenv()
{
    _vcfindenv
} #vcfindenv

function vcfreeze()
{
    _vcfreeze
} #vcfreeze

function vcactivate()
{
    _vcactivate
} #vcactivate
alias vca='vcactivate'


function vctags()
{
    _vctags
} #vctags

function vcbundle()
{
    _vcbundle
} #vcbundle

function vc_auto_activate()
{
    _vc_auto_activate
} #vc_auto_activate

# Automatically activate the current directories
# Virtualenv is one exists
if [[ "$VC_AUTO_ACTIVATION" == "true" ]]; then
    if [[ -n "$PROMPT_COMMAND" ]]; then
        export VC_OLD_PROMPT_COMMAD="$PROMPT_COMMAND"
        PROMPT_COMMAND="$PROMPT_COMMAND;vc_auto_activate"
    else
        PROMPT_COMMAND="vc_auto_activate"
    fi
fi

# vim:set ft=sh:
