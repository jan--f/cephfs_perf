#!/bin/bash

run_cmd(){
    echo $1
}


# parse command line
while [[ $# -gt 0 ]]; do
key="$1"

case $key in
    -d|--directory)
    OUTDIR="$2"
    shift # past argument
    ;;
    -h|--hostfile)
    HOSTFILE="$2"
    shift # past argument
    ;;
    -l|--logdir)
    LOGDIR="$2"
    shift
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

# set default directory if no option was passed on cli
if [ -z $OUTDIR ]; then
    OUTDIR=$(pwd)/files
    echo "using $OUTDIR as output directory"
fi

if [ -z $LOGDIR ]; then
    LOGDIR=$(pwd)/logs
fi

# create fio job files from template
for jobtemp in $(find jobs -name \*.fio.in); do
    sed "s~<dir>~$OUTDIR~" $jobtemp > ${jobtemp%.*}
done

for job in $(find jobs -name \*.fio); do
    jobname=$(basename $job)
    echo "${jobname%.*}"
    LOGFILE=$LOGDIR/$jobname.log

    if [ -z $HOSTFILE ]; then
        cmd="fio $job > $LOGFILE"
    else
        cmd="fio --client=$HOSTFILE $job > $LOGFILE"
    fi

    run_cmd "$cmd"
    echo
    echo "removing work files..."
    rm_cmd="rm $OUTDIR/*"
    run_cmd "$rm_cmd"
done
