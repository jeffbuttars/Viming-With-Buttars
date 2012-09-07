virtualcandy
============

My Own Bash Wrapper Functions for Python's Virtualenv

## Installation

Clone the repo into your home directory:

    ```sh
    git git@github.com:jeffbuttars/virtualcandy.git .virtualcandy
    ```

Source VirtualCandy from your bashrc, add this line to your ~/.bashrc file:

    ```sh
    . ~/.virtualcandy/virtualcandy.sh
    ```


## Philosophy of Virtualenv usage

My usage of Virtualenv is very similar to how one uses Git or Hg.
I create on Virtualenv environment per project and that Virtualenv environment
is located at the top of the project's directory tree. I also name 
all of my Virtualenv directories the same name, .venv, and this project
uses that as the default Virtualenv directory name. But that is configurable.  

Most VirtualCandy functions can be used from anyware withing a project using a
Virtualenv. VirtualCandy will find the nearest install Virtualenv by traversing
up the directory tree until one or no Virtualenvs are found.

## Configuration

Set the following environemental variables in your ~/.bashrc, before
you source the virtualcandy.sh file, to configure VirtualCandy settings.


### Set the name of your Virtualenv directory created by and used by VirtualCandy
    VC_DEFUALT_VENV_NAME='.venv'


### Set the name of the requirements file used by pip freeze and VirtualCandy to store your installed package information

    VC_DEFUALT_VENV_REQFILE='requirements.txt'

## Function Overview

### vcstart

Start a new virtualenv, or rebuild one from a requirements file. This
function only works on your current working directory(all other functions work
anyware within a Virtualenv project). If you run vcstart in a
directory without a Virtualenv of the name defined by `$VC_DEFUALT_VENV_NAME` ,
then a new Virtualenv will be created. After the Virtualenv is created, if a
requirements file is present, all of the packages listed in the
requirements file will be installed. If a Virtualenv defined by the name
`$VC_DEFUALT_VENV_NAME` already exists and a requirements file exists then no
new Virtualenv will be created, the packages listed in requirements file will be
installed/updated if necessary.

### vcfreeze

Write a new requirements file for the current Virtualenv. The
requirements file contents are the result of the `pip freeze` command. The
requirements file is written in the same directory that contains the
Virtualenv directory, even if the command is ran in a subdirectory.
If you don't want to name the output file to be `requirements.txt`, you can
change the name of the output file with the `$VC_DEFUALT_VENV_REQFILE`
environemental variable.

### vcpkgup

This will upgrade all of the packages listed in the requirements file to their
latest version and then re-write the requirements file to reflect the update.

### vcactivate

`vcactivate` will activate the Virtualenv of the current project. `vcactivate` finds
the current project by using the `vcfindenv` command.

### vctags

TODO: Make the inotify watch optional with a command line flag
TODO: Make the Virtualenv name option a command line flag 

Runs ctags and creates a tags file in your current working directory. The
Virtualenv directory of the current project will be explicitly scanned by ctags
and included in the tags file. If no parameters are given to `vctags` then the
current working directory will also be recursively added to the tags file. Any
parameters given to the `vctags` command will be treated as files and/or
directories that should be scanned by ctags. 

#### File Watching

If `inotify-utils` is installed, then the `vctags` command will monitor the
directories/files used to generate the tags from and regenerate the tags file
every time there is a modification to the watched files.  

`vctags` always runs ctags with the following options:  
    `ctags --sort=yes --tag-relative=no -R --python-kinds=-i $VENV_LOCATION`

Where `$VENV_LOCATION` is the current project's Virtualenv directory.

If no options are given to `vctags` then the following ctags command is run:  
    `ctags --sort=yes --tag-relative=no -R --python-kinds=-i $VENV_LOCATION *`
Note the additional `*` at the end of the command.  

If `vctags` is given parameters, then ctags is run as:  
    `ctags --sort=yes --tag-relative=no -R --python-kinds=-i $VENV_LOCATION $@`  
Where `$@` is all of the parameters passed to the `vctags` command.


### vcfindenv

This will find and print the full path of the current project's Virtualenv
locatin.  
This function is intended for internal use by VirtualCandy iteself, but it is
available to the user.

### vcfinddir

This is used to find the nearest directory containing the Virtualenv named by
the `$VC_DEFUALT_VENV_NAME` bash variable. For instance you have Virtualenv
located at:
    `/home/user/project`
and you run vcfinddir from the directory:
    `/home/user/proejct/a/subdir`
the result will be:
    `/home/user/project`
This function is intended for internal use by VirtualCandy iteself, but it is
available to the user.

