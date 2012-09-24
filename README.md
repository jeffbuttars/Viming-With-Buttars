virtualcandy
============

### My Own Bash Wrapper Functions for [Python's](http://www.python.org/) [Virtualenv](http://www.virtualenv.org/en/latest/index.html)  

This not an attempt to create another, or even better, set of wrapper functions
for [Virtualenv](http://www.virtualenv.org/en/latest/index.html). This is a set of wrappers that I've built, like, and use
everyday.

## Installation

Clone the repo into your home directory:

    git git@github.com:jeffbuttars/virtualcandy.git .virtualcandy

Source VirtualCandy from your bashrc, add this line to your ~/.bashrc file:

    . ~/.virtualcandy/virtualcandy.sh


## Philosophy of [Virtualenv](http://www.virtualenv.org/en/latest/index.html) usage

My usage of [Virtualenv](http://www.virtualenv.org/en/latest/index.html) is very similar to how one uses Git or Hg.
I create one [Virtualenv](http://www.virtualenv.org/en/latest/index.html) environment per project and that [Virtualenv](http://www.virtualenv.org/en/latest/index.html) environment
is located at the top of the project's directory tree. I also name 
all of my [Virtualenv](http://www.virtualenv.org/en/latest/index.html) directories the same name, .venv, and this project
uses that as the default [Virtualenv](http://www.virtualenv.org/en/latest/index.html) directory name. But that is configurable.  

Most VirtualCandy functions can be used from anyware within a project using a
[Virtualenv](http://www.virtualenv.org/en/latest/index.html). VirtualCandy will find the nearest install of [Virtualenv](http://www.virtualenv.org/en/latest/index.html) by traversing
up the directory tree until one or no [Virtualenv](http://www.virtualenv.org/en/latest/index.html) are found.

## Installation and Configuration

### Installation

Check out the code. I use a ~/.virtualcandy directory to hold the code, but the
location doesn't matter much.

    cd; git git://github.com/jeffbuttars/virtualcandy.git .virtualcandy 

To enable VirtualCandy, you just source it in your ~/.bashrc file. Add the
following line into your ~/.bashrc file:  

    . ~/.virtualcandy/virtualcandy.sh

That's it, VirtualCandy is installed!

### Configuration

Set the following environemental variables in your ~/.bashrc, before
you source the virtualcandy.sh file, to configure VirtualCandy settings.  

#### Set the name of your [Virtualenv](http://www.virtualenv.org/en/latest/index.html) directory created by and used by VirtualCandy

    VC_DEFUALT_VENV_NAME='.venv'


#### Set the name of the requirements file used by [Pip](http://pypi.python.org/pypi/pip) freeze and VirtualCandy to store your installed package information

    VC_DEFUALT_VENV_REQFILE='requirements.txt'

#### Enable auto activation, when set to 'true', of a [Virtualenv](http://www.virtualenv.org/en/latest/index.html) when you enter it's containing directory. If you use [Virtualenv](http://www.virtualenv.org/en/latest/index.html) often, this is a very handy option. Example: If you have a directory named ~/Dev1 that has a [Virtualenv](http://www.virtualenv.org/en/latest/index.html) in it. Then upon changing into the ~/Dev1 directory that [Virtualenv](http://www.virtualenv.org/en/latest/index.html) will be activated. If you a [Virtualenv](http://www.virtualenv.org/en/latest/index.html) activated and cd into a directory containing a [Virtualenv](http://www.virtualenv.org/en/latest/index.html) that is different from the currently activated [Virtualenv](http://www.virtualenv.org/en/latest/index.html), then the current [Virtualenv](http://www.virtualenv.org/en/latest/index.html) will be deactivated and the new one will be activated.

    VC_AUTO_ACTIVATION=false

## Function Overview

### vcstart

Start a new virtualenv, or rebuild one from a requirements file. This
function only works on your current working directory(all other functions work
anyware within a [Virtualenv](http://www.virtualenv.org/en/latest/index.html) project). If you run `vcstart` in a
directory without a [Virtualenv](http://www.virtualenv.org/en/latest/index.html) of the name defined by `$VC_DEFUALT_VENV_NAME` ,
then a new [Virtualenv](http://www.virtualenv.org/en/latest/index.html) will be created. After the [Virtualenv](http://www.virtualenv.org/en/latest/index.html) is created, if a
requirements file is present, all of the packages listed in the
requirements file will be installed. If a [Virtualenv](http://www.virtualenv.org/en/latest/index.html) defined by the name
`$VC_DEFUALT_VENV_NAME` already exists and a requirements file exists then no
new [Virtualenv](http://www.virtualenv.org/en/latest/index.html) will be created, the packages listed in requirements file will be
installed/updated if necessary.

### vcactivate

`vcactivate` will activate the [Virtualenv](http://www.virtualenv.org/en/latest/index.html) of the current project. `vcactivate` finds
the current project by using the `vcfindenv` command.

### vcfreeze

Write a new requirements file for the current [Virtualenv](http://www.virtualenv.org/en/latest/index.html). The
requirements file contents are the result of the `pip freeze` command. The
requirements file is written in the same directory that contains the
[Virtualenv](http://www.virtualenv.org/en/latest/index.html) directory, even if the command is ran in a subdirectory.
If you don't want to name the output file to be `requirements.txt`, you can
change the name of the output file with the `$VC_DEFUALT_VENV_REQFILE`
environemental variable.

### vcpkgup

This will upgrade all of the packages listed in the requirements file to their
latest version and then re-write the requirements file to reflect the update.

### vctags

TODO: Make the inotify watch optional with a command line flag  
TODO: Make the [Virtualenv](http://www.virtualenv.org/en/latest/index.html) name option a command line flag   

Runs ctags and creates a tags file in your current working directory. The
[Virtualenv](http://www.virtualenv.org/en/latest/index.html) directory of the current project will be explicitly scanned by ctags
and included in the tags file. If no parameters are given to `vctags` then the
current working directory will also be recursively added to the tags file. Any
parameters given to the `vctags` command will be treated as files and/or
directories that should be scanned by ctags. 

### vcbundle

Creates a package bundle containing all of the packages listed in the current [Virtualenv](http://www.virtualenv.org/en/latest/index.html)'s VC\_DEFUALT\_VENV\_REQFILE file. The name of the bundle output will be 'VC\_DEFUALT\_VENV\_NAME.pybundle', but with any leading '.' stripped from the [Virtualenv](http://www.virtualenv.org/en/latest/index.html) name. For instance, if VC\_DEFUALT\_VENV\_NAME is '.myenv' the bundle will be named 'myenv.pybundle'.

#### File Watching

If `inotify-utils` is installed, then the `vctags` command will monitor the
directories/files used to generate the tags from and regenerate the tags file
every time there is a modification to the watched files.  

`vctags` always runs ctags with the following options:  
    `ctags --sort=yes --tag-relative=no -R --python-kinds=-i $VENV_LOCATION`

Where `$VENV_LOCATION` is the current project's [Virtualenv](http://www.virtualenv.org/en/latest/index.html) directory.

If no options are given to `vctags` then the following ctags command is run:  
    `ctags --sort=yes --tag-relative=no -R --python-kinds=-i $VENV_LOCATION *`
Note the additional `*` at the end of the command.  

If `vctags` is given parameters, then ctags is run as:  
    `ctags --sort=yes --tag-relative=no -R --python-kinds=-i $VENV_LOCATION $@`  
Where `$@` is all of the parameters passed to the `vctags` command.

### vc\_auto\_activate

Checks the current directory for a [Virtualenv](http://www.virtualenv.org/en/latest/index.html) named VC\_DEFUALT\_VENV\_NAME. If it exists it is activated. This function is put into the PROMPT\_COMMAND variable and executed on every changed of directory.  
This function is intended for internal use by VirtualCandy iteself, but it is
available to the user.

### vcfindenv

This will find and print the full path of the current project's [Virtualenv](http://www.virtualenv.org/en/latest/index.html)
locatin.  
This function is intended for internal use by VirtualCandy iteself, but it is
available to the user.

### vcfinddir

This is used to find the nearest directory containing the [Virtualenv](http://www.virtualenv.org/en/latest/index.html) named by
the `$VC_DEFUALT_VENV_NAME` bash variable. For instance you have [Virtualenv](http://www.virtualenv.org/en/latest/index.html)
located at:
    `/home/user/project`
and you run vcfinddir from the directory:
    `/home/user/proejct/a/subdir`
the result will be:
    `/home/user/project`
This function is intended for internal use by VirtualCandy iteself, but it is
available to the user.


## References

* [Python](http://www.python.org/)
* [Virtualenv](http://www.virtualenv.org/en/latest/index.html)
* [Pip](http://pypi.python.org/pypi/pip)
