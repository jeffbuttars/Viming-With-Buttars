# VirtualCandy
# Use at your own risk, no quarentee provided.
# Author: Jeff Buttars
# git@github.com:jeffbuttars/virtualcandy.git
# See the README.md

if [[ -z $VC_DEFUALT_VENV_NAME ]]; then
    VC_DEFUALT_VENV_NAME='.venv'
fi

if [[ -z $VC_DEFUALT_VENV_REQFILE ]]; then
    VC_DEFUALT_VENV_REQFILE='requirements.txt'
fi

function vcfinddir()
{
    cur=$PWD
    vname=$VC_DEFUALT_VENV_NAME
    found='false'

    if [[ -n $1 ]]; then
        vname="$1"
    fi

    while [[ "$cur" != "/" ]]; do
        # echo "cur == $cur"
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
} #vcfinddir

# Start a new virtualenv, or 
# rebuild on from a requirements.txt file.
function vcstart()
{
    vname=$VC_DEFUALT_VENV_NAME
    if [[ -n $1 ]]; then
        vname="$1"
    fi

    virtualenv $vname
    . $vname/bin/activate

    if [[ -f requirements.txt ]]; then
        pip install -r $VC_DEFUALT_VENV_REQFILE
    else
        touch $VC_DEFUALT_VENV_REQFILE
    fi
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
} #pip_update

# Upgrade the nearest virtualenv packages
# and re-freeze them
function vcpkgup()
{
    vname=$VC_DEFUALT_VENV_NAME

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
} #vcpkgup


function vcfindenv()
{
    cur=$PWD
    vname=$VC_DEFUALT_VENV_NAME

    if [[ -n $1 ]]; then
        vname="$1"
    fi

    vdir=$(vcfinddir $vname)
    res=""
    if [[ -n $vdir ]]; then
        res="$vdir/$vname"
    fi
    echo $res

} #vcfindenv

function vcfreeze()
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
} #vcfreeze

function vcactivate()
{
    
    vloc=''

    if [[ -n $1 ]]; then
        vloc=$(vcfindenv $1)
    else
        vloc=$(vcfindenv)
    fi

    if [[ -n $vloc ]]; then
        echo "Activating $cur/$vname"
        . "$vloc/bin/activate"
    else
        echo "No virtualenv name $vname found."
    fi

} #vcactivate
alias vca='vcactivate'

function vctags()
{
    
    # vloc=''
    # if [[ -n $1 ]]; then
    #     vloc=$(vcfindenv $1)
    # else
    #     vloc=$(vcfindenv)
    # fi
    # shift

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
    if [[ -n $res ]]; then
        while [[ true ]]; do
            inotifywait -e modify -r $filelist
            $ccmd
        done
    fi
} #vctags

# vim:set ft=sh:
