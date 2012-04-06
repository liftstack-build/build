#!/usr/bin/env bash

# build the giter8 lift template

# Requires:
# giter8 installed and on your PATH (easy way get this is to use the Typesafe Stack)

# Usage:
# sh build-lift-giter8-project.sh [giter8-project-template-dir] [lift-template-dir] [helper-dir] [target-project-dir-name.g8]

# Components:
# 1.  ./lift_blank (blank lift template using lift 2.4 and scala 2.9, from https://github.com/lift/lift_24_sbt)
# 2.  ./giter8 project template (created by running 'g8 n8han/giter8')
# 3.  ./lift-helpers (.gitconfig, README.md)

# Steps:
# TLDR - start with giter8 project template, then copy lift components and helpers into it
# 0.  Test if target project directory exists:
# 1.  copy giter8 template to new working directory
# 2.  copy lift blank template to new working directory, but put lift/src in [working dir]/src/main/g8/src
# 3.  delete lift template's sbt* from working directory (assuming you have sbt already installed and on PATH)
# 4.  copy .gitignore and README.md from helpers to working directory, overwriting current ones

# Default params
GITER8="./giter8-default"
LIFT="./lift_blank"
HELPERS="./lift-helpers"
TARGET="./lift24-s29-blank.g8"

# Commandline param overide
if [ $1 ]; then GITER8=$1; fi
if [ $2 ]; then LIFT=$2; fi
if [ $3 ]; then HELPERS=$3; fi
if [ $4 ]; then TARGET=$4; fi

echo "Building with:"
echo "GITER8:   $GITER8"
echo "LIFT:     $LIFT"     
echo "HELPERS:  $HELPERS" 
echo "TARGET:   $TARGET" 

if [ -d "$TARGET" ]; then 
    if [ -L "$TARGET" ]; then
        # Target dir exists and is a symlink.
        # Symbolic link specific commands go here
        #rm "$TARGET"
        echo "$TARGET exists.  It's a symlink.  Please rename it or change your project directory name."
    else
        # Target dir exists and is a directory.
        # Directory command goes here
        #rmdir "$TARGET"
        echo "$TARGET exists.  It's a directory.  Please rename it or change your project directory name."
    fi
else
    # Target dir does not exist, proceed with build:
    mkdir -p $TARGET
    cp -r $GITER8/* $TARGET
    rm -rf $TARGET/src/main/g8/src/*
    cp -r $LIFT/src/* $TARGET/src/main/g8/src
    cp -r $LIFT/project/* $TARGET/project
fi
