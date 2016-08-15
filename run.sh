#!/bin/bash

# parse command line
while [[ $# -gt 0 ]]; do
key="$1"

case $key in
    -d|--directory)
    DIR="$2"
    shift # past argument
    ;;
    -h|--hostfile)
    HOSTFILE="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

# set default directory if no option was passed on cli
if [ -z $DIR ]; then
DIR=$(pwd)
fi

export OUTDIR=$DIR/files
LOGDIR=$DIR/logs

# create fio job files from template
for jobtemp in $(find jobs -name \*.fio.in); do
    sed "s~<dir>~$OUTDIR~" $jobtemp > ${jobtemp%.*}
done

echo "using $OUTDIR as output directory"

# create necessary dirs
if [ ! -d files ]; then
    echo 'creating directory ' $OUTDIR
    mkdir $DIR/files
else
    echo "clean up files"
    rm $OUTDIR/*
fi

if [ ! -d logs ]; then
    echo 'creating directory ' $LOGDIR
    mkdir logs
fi

for job in $(find jobs -name \*.fio); do
    jobname=$(basename $job)
    echo "${jobname%.*}"
    LOGFILE=$LOGDIR/$jobname.log

    if [ -z $HOSTFILE ]; then
        cmd="fio $job > $LOGFILE"
    else
        cmd="fio --client=$HOSTFILE $job > $LOGFILE"
    fi

    echo $cmd
    #eval $cmd
    echo
    echo "removing work files..."
    rm $OUTDIR/*
done
