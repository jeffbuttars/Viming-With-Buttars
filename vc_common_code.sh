# VirtualCandy
# Use at your own risk, no quarentee provided.
# Author: Jeff Buttars
# git@github.com:jeffbuttars/virtualcandy.git
# See the README.md


# Common code sourced by both bash and zsh
# implimentations of virtualcandy.
# Shell specific code goes into each shells
# primary file.

if [[ -z $VC_DEFUALT_VENV_NAME ]]
then
    VC_DEFUALT_VENV_NAME='.venv'
fi

if [[ -z $VC_DEFUALT_VENV_REQFILE ]]
then
    VC_DEFUALT_VENV_REQFILE='requirements.txt'
fi

if [[ -z $VC_AUTO_ACTIVATION ]]
then
    VC_AUTO_ACTIVATION=false
fi

function _vcfinddir()
{
    cur=$PWD
    vname=$VC_DEFUALT_VENV_NAME
    found='false'

    if [[ -n $1 ]]; then
        vname="$1"
    fi

    while [[ "$cur" != "/" ]]; do
        if [[ -d "$cur/$vname" ]]; then
            found="true"
            echo "$cur"
            break
        fi

        cur=$(dirname $cur)
    done

    if [[ "$found" == "false" ]]; then
        echo ""
    fi
} #_vcfinddir

# Start a new virtualenv, or 
# rebuild on from a requirements.txt file.
function _vcstart()
{
    vname=$VC_DEFUALT_VENV_NAME
    if [[ -n $1 ]]; then
        if [[ "$1" != "-" ]]; then
            vname="$1"
        fi
        shift
    fi

    virtualenv $vname
    . $vname/bin/activate

    if [[ -f requirements.txt ]]; then
        pip install -r $VC_DEFUALT_VENV_REQFILE
    else
        touch $VC_DEFUALT_VENV_REQFILE
    fi

    for pkg in $@ ; do
        pip install $pkg
    done

    vcfreeze
} #_vcstart

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
function _pip_update()
{
    reqf="requirements.txt"

    if [[ -n $VC_DEFUALT_VENV_REQFILE ]]; then
        reqf="$VC_DEFUALT_VENV_REQFILE"
    fi

    if [[ -n $1 ]]; then
        reqf="$1"
    fi

    res=0
    if [[ -f $reqf ]]; then
        tfile="/tmp/pkglist_$RANDOM.txt"
        echo $tfile
        cat $reqf | awk -F '==' '{print $1}' > $tfile
        pip install --upgrade -r $tfile
        res=$?
        rm -f $tfile
    else
        echo "Unable to find package list file: $reqf"
        res=1
    fi

    return $res
} #_pip_update

# Upgrade the nearest virtualenv packages
# and re-freeze them
function _vcpkgup()
{
    local vname=$VC_DEFUALT_VENV_NAME

    if [[ -n $1 ]]; then
        vname="$1"
    fi

    vdir=$(vcfinddir $vname)

    reqlist="$vdir/$VC_DEFUALT_VENV_REQFILE"
    echo "Using req list $reqlist"

    if [[ -f $reqlist ]]; then
        vcactivate $vname
        pip_update $reqlist
        res=$?
        if [[ "$res" == 0 || "$res" == "" ]]; then
            vcfreeze $vname
        else
            echo "Bad exit status from pip_update, not freezing the package list."
        fi
    fi
    
    return $res
} #_vcpkgup

function _vcfindenv()
{
    cur=$PWD
    local vname=$VC_DEFUALT_VENV_NAME

    if [[ -n $1 ]]; then
        vname="$1"
    fi

    vdir=$(vcfinddir $vname)
    res=""
    if [[ -n $vdir ]]; then
        res="$vdir/$vname"
    fi
    echo $res

} #_vcfindenv

function _vcfreeze()
{
    vd=''
    if [[ -n $1 ]]; then
        vd=$(vcfinddir $1)
    else
        vd=$(vcfinddir)
    fi

    vcactivate

    pip freeze > "$vd/$VC_DEFUALT_VENV_REQFILE"
    cat  "$vd/$VC_DEFUALT_VENV_REQFILE"
} #_vcfreeze

function _vcactivate()
{
    
    local vname=$VC_DEFUALT_VENV_NAME
    vloc=''

    if [[ -n $1 ]]; then
        vname="$1"
    fi

    vloc=$(vcfindenv)

    if [[ -n $vloc ]]; then
        echo "Activating ~${vloc#$HOME/}"
        . "$vloc/bin/activate"
    else
        echo "No virtualenv name $vname found."
    fi

} #_vcactivate

function _vctags()
{
    vloc=$(vcfindenv)
    filelist="$vloc"

    ccmd="ctags --sort=yes --tag-relative=no -R --python-kinds=-i"
    if [[ -n $vloc ]]; then
        echo "Making tags with $vloc"
        filelist="$vloc"
    fi

    if [[ "$#" == "0" ]]; then
        filelist="$filelist *"
    else
        filelist="$filelist $@"
    fi

    ccmd="$ccmd $filelist"
    echo "Using command $ccmd"
    $ccmd

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


function _vcbundle()
{
    vcactivate
    vdir=$(vcfinddir)
    bname="${VC_DEFUALT_VENV_NAME#.}.pybundle"
    echo "Creating bundle $bname"
    pip bundle "$bname" -r "$vdir/$VC_DEFUALT_VENV_REQFILE"
} #_vcbundle


function _vcmod()
{
    if [[ -z $1 ]]
    then
        echo "$0: A module name is required."
        exit 1
    fi 

    mkdir -p "$1"
    if [[ ! -f "$1/__init__.py" ]]
    then
        touch "$1/__init__.py" 
    else
        echo "$0: A module named $1 already exists."
    fi
} #_vcmod

function _vc_auto_activate()
{
    if [[ -d "$VC_DEFUALT_VENV_NAME" ]]; then
        if [[ -n $VIRTUAL_ENV ]]; then
            if [[ "$VIRTUAL_ENV" != "$PWD/$VC_DEFUALT_VENV_NAME" ]]; then
                from="~${VIRTUAL_ENV#$HOME/}"
                to="$(vcfindenv)"
                to="~${to#$HOME/}"
                echo -e "Switching from $from to $to"
                deactivate
            fi
        fi

        vcactivate
    fi
} #_vc_auto_activate

