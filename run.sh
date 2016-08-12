#!/bin/bash

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

if [ -z $DIR ]; then
DIR=$(pwd)
fi

OUTDIR=$DIR/files
LOGDIR=$DIR/logs

echo "using $OUTDIR as output directory"

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
        cmd="fio --directory=$OUTDIR $job > $LOGFILE"
    else
        cmd="fio --client=$HOSTFILE --directory=$OUTDIR $job > $LOGFILE"
    fi

    echo $cmd
    cmd$
    echo
    echo "removing work files..."
    rm $OUTDIR/*
done
