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
        tfile="/tmp/pkglist_$RANDOM.txt"
        echo $tfile
        cat $reqlist | awk -F '==' '{print $1}' > $tfile
        vcactivate $vname
        pip install --upgrade -r $tfile
        vcfreeze $vname
        rm -f $tfile
    fi
    
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
