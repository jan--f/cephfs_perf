#!/bin/bash

if [ ! -d files ]; then
    echo 'creating directory "files"'
    mkdir files
else
    echo "clean up files dir"
    rm files/*
fi

if [ ! -d logs ]; then
    echo 'creating directory "logs"'
    mkdir logs
fi

if [ $# -eq 0 ]; then
    echo 'using all jobfiles under dir "jobs"'
    if [ ! -d jobs ]; then
        echo 'dir "jobs does not exist...giving up"'
        exit 1
    fi
    DIR=./jobs
else
    echo 'looking for jobs under ' $1
    DIR=$1
fi

for job in $(find $DIR -name \*.fio); do
    jobname=$(basename $job)
    echo "${jobname%.*}"
    echo "fio $job > logs/$jobname.log"

    echo "removing work files..."
    rm files/*
done
