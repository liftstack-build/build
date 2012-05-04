#!/usr/bin/env bash

# quick script to compile and format cmdline params for getopts in build script
# $1 is input, single column list of cmdline params
# $2 is formatted output file, single line of cmdline parmas separated with :

tr '\n' ':' <$! >>$2
