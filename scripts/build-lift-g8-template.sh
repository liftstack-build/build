#!/usr/bin/env bash

# build the giter8 lift template

# Requires:
# giter8 [1] installed and on your PATH.  Easy way get this is to use the Typesafe Stack [2].
# [1]: http://github.com/n8han/giter8 
# [2]: http://typesafe.com/stack/download

# Usage:
# sh build-lift-giter8-project.sh
# assumes giter8-default/, lift-helpers/, and lift_blank/ (or lift_basic/, lift_mvc/, 
#   or other lift_[sbt-template]) in same directory.
# use commandline params below to override defaults

# Components:
# 1.  ./lift_blank (blank lift template using lift 2.4 and scala 2.9) [3] 
# 2.  ./giter8 project template (created by running 'g8 n8han/giter8')
# 3.  ./lift-helpers (.gitconfig, README.md)
# [3]: https://github.com/lift/lift_24_sbt

# Steps:
# TLDR - copy giter8 project template to target dir, then copy lift components and helpers into it, modify config files
# 0.  Test if target project directory exists:
# 1.  copy giter8 template to new working directory ($TARGET)
# 2.  copy lift blank template to $TARGET, but put lift/src in $TARGET]/src/main/g8/src and lift/project in $TARGET/src/main/g8/project
# 3.  delete lift template's sbt* files from $TARGET/src/main/g8/ (will use sbt already installed on PATH instead)
# 4.  copy .gitignore and README.md from helpers to $TARGET, overwriting current ones
# 5.  use sed to modify several config files

# Default params
GITER8="./giter8-default"                   #-g8-loc; -gl
LIFT="./lift_blank"                         #-lift-loc; -ll
HELPERS="./lift-helpers"                    #-helpers-loc; -hl
TARGET="./lift24-s29-blank.g8"              #-target-loc; -tl
LIFT_BOOT="$TARGET/src/main/g8/src/main/scala/bootstrap/liftweb/Boot.scala"     #lift-boot; -lb
LIFT_BOOT_PATTERN="def boot {"              #-lift-boot-pattern; -lbp
LIFT_HTML5_SNIPPET="$HELPERS/html5-boot.scala" #-lift-html5-snippet; -lhs

# Lift properties config file
DEFAULT_LIFT_PROPERTIES="$TARGET/src/main/g8/project/build.properties"
DEFAULT_PROJECT_ORGANIZATION="project.organization"
DEFAULT_PROJECT_NAME="project.name"
DEFAULT_SBT_VERSION="sbt.version"
DEFAULT_PROJECT_VERSION="project.version"
DEFAULT_DEF_SCALA_VERSION="def.scala.version"
DEFAULT_BUILD_SCALA_VERSIONS="build.scala.versions"
DEFAULT_PROJECT_INITIALIZE="project.initialize"
DEFAULT_LIFT_VERSION="lift.version"

# Lift properties default values
LIFT_PROPERTIES="$DEFAULT_LIFT_PROPERTIES"  #-lift-properties; -lp
PROJECT_ORGANIZATION="Lift"                 #-project-org; -po
PROJECT_NAME="Lift SBT Template"            #-project-name; -pn
SBT_VERSION="0.11.2"                        #-sbt-version; -sv
PROJECT_VERSION="0.1"                       #-project-version; -pv
DEF_SCALA_VERSION="2.9.0-1"                 #-def-scala-version; -dsv
BUILD_SCALA_VERSIONS="2.9.0-1"              #-build-scala-versions; -bsv
PROJECT_INITIALIZE="false"                  #-project-initialize; -pi
LIFT_VERSION="2.4"                          #-lift-version; -lv

# override above vars with any passed commandline opts (getops can't parse GNU style \
# -- long options, so both long and short denoted by single - )
while getopts "g8-loc:gl:lift-loc:ll:helpers-loc:hl:target-loc:tl:lift-boot:lb:\
    lift-boot-pattern:lbp:lift-html5-snippet:lhs:project-org:po:project-name:pn:\
    sbt-version:sv:project-version:pv:def-scala-version:dsv:build-scala-versions:\
    bsv:project-initialize:pi:lift-version:lv" optionName; do
    case "$optionName" in 
        g8-loc)                 GITER8="$OPTARG";;
        gl)                     GITER8="$OPTARG";;
        lift-loc)               LIFT="$OPTARG";;
        ll)                     LIFT="$OPTARG";;
        helpers-loc)            HELPERS="$OPTARG";;
        hl)                     HELPERS="$OPTARG";;
        target-loc)             TARGET="$OPTARG";;
        tl)                     TARGET="$OPTARG";;
        lift-boot)              LIFT_BOOT="$OPTARG";;
        lb)                     LIFT_BOOT="$OPTARG";;
        lift-boot-pattern)      LIFT_BOOT_PATTERN="$OPTARG";;
        lbp)                    LIFT_BOOT_PATTERN="$OPTARG";;
        lift-html5-snippet)     LIFT_HTML5_SNIPPET="$OPTARG";;
        lhs)                    LIFT_HTML5_SNIPPET="$OPTARG";;
        lift-properties)        LIFT_PROPERTIES="$OPTARG";;
        lp)                     LIFT_PROPERTIES="$OPTARG";;
        project-org)            PROJECT_ORGANIZATION="$OPTARG";;
        po)                     PROJECT_ORGANIZATION="$OPTARG";;
        project-name)           PROJECT_NAME="$OPTARG";;
        pn)                     PROJECT_NAME="$OPTARG";;
        sbt-version)            SBT_VERSION="$OPTARG";;
        sv)                     SBT_VERSION="$OPTARG";;
        project-version)        PROJECT_VERSION="$OPTARG";;
        pv)                     PROJECT_VERSION="$OPTARG";;
        def-scala-version)      DEF_SCALA_VERSION="$OPTARG";;
        dsv)                    DEF_SCALA_VERSION="$OPTARG";;
        build-scala-versions)   BUILD_SCALA_VERSIONS="$OPTARG";;
        bsv)                    BUILD_SCALA_VERSIONS="$OPTARG";;
        project-initialize)     PROJECT_INITIALIZE="$OPTARG";;
        pi)                     PROJECT_INITIALIZE="$OPTARG";;
        lift-version)           LIFT_VERSION="$OPTARG";;
        lv)                     LIFT_VERSION="$OPTARG";;
        [?]) printErrorHelpAndExit "$badOptionHelp";;
    esac
done

echo "Building with:"
echo "GITER8:               $GITER8"
echo "LIFT:                 $LIFT"     
echo "HELPERS:              $HELPERS" 
echo "TARGET:               $TARGET" 
echo "LIFT_BOOT:            $LIFT_BOOT" 
echo "LIFT_BOOT_PATTERN:    $LIFT_BOOT_PATTERN"
echo "LIFT_HTML5_SNIPPET:   $LIFT_HTML5_SNIPPET"
echo "LIFT_PROPERTIES:      $LIFT_PROPERTIES"
echo "PROJECT_ORGANIZATION: $PROJECT_ORGANIZATION"
echo "PROJECT_NAME:         $PROJECT_NAME"
echo "SBT_VERSION:          $SBT_VERSION"
echo "PROJECT_VERSION:      $PROJECT_VERSION"
echo "DEF_SCALA_VERSION:    $DEF_SCALA_VERSION"
echo "BUILD_SCALA_VERSIONS: $BUILD_SCALA_VERSIONS"
echo "PROJECT_INITIALIZE:   $PROJECT_INITIALIZE"
echo "LIFT_VERSION:         $LIFT_VERSION"


# Main
if [ -d "$TARGET" ]; then 
    if [ -L "$TARGET" ]; then
        # Target dir exists and is a symlink.
        # Symbolic link specific commands go here
        #rm "$TARGET"
        echo "$TARGET exists.  It's a symlink.  Please remove it, rename it, or change your TARGET name."
        echo "Aborting..."
    else
        # Target dir exists and is a directory.
        # Directory command goes here
        #rmdir "$TARGET"
        echo "$TARGET exists.  It's a directory.  Please remove it, rename it, or change your TARGET name."
        echo "Aborting..."
    fi
else
    # Target dir does not exist, proceed with build:
    mkdir -p $TARGET
    cp -r $GITER8/* $TARGET
    rm -rf $TARGET/src/main/g8/src/*
    cp -r $LIFT/src/* $TARGET/src/main/g8/src
    cp -r $LIFT/project/ $TARGET/src/main/g8/
    cp -r $HELPERS/README.md $TARGET
    cp -r $HELPERS/.gitignore $TARGET

    # insert html5 enabler into Boot.scala
    sed -i "/$LIFT_BOOT_PATTERN/r $LIFT_HTML5_SNIPPET" $LIFT_BOOT
    
    # update Lift build.properties
    sed -i "s/$DEFAULT_PROJECT_ORGANIZATION=.*/$DEFAULT_PROJECT_ORGANIZATION=$PROJECT_ORGANIZATION/" $LIFT_PROPERTIES
    sed -i "s/$DEFAULT_PROJECT_NAME=.*/$DEFAULT_PROJECT_NAME=$PROJECT_NAME/" $LIFT_PROPERTIES
    sed -i "s/$DEFAULT_SBT_VERSION=.*/$DEFAULT_SBT_VERSION=$SBT_VERSION/" $LIFT_PROPERTIES
    sed -i "s/$DEFAULT_PROJECT_VERSION=.*/$DEFAULT_PROJECT_VERSION=$PROJECT_VERSION/" $LIFT_PROPERTIES
    sed -i "s/$DEFAULT_DEF_SCALA_VERSION=.*/$DEFAULT_DEF_SCALA_VERSION=$DEF_SCALA_VERSION/" $LIFT_PROPERTIES
    sed -i "s/$DEFAULT_BUILD_SCALA_VERSIONS=.*/$DEFAULT_BUILD_SCALA_VERSIONS=$BUILD_SCALA_VERSIONS/" $LIFT_PROPERTIES
    sed -i "s/$DEFAULT_PROJECT_INITIALIZE=.*/$DEFAULT_PROJECT_INITIALIZE=$PROJECT_INITIALIZE/" $LIFT_PROPERTIES
    sed -i "s/$DEFAULT_LIFT_VERSION=.*/$DEFAULT_LIFT_VERSION=$LIFT_VERSION/" $LIFT_PROPERTIES


    # add Lifty to $TARGET/build.sbt
    
    # add Lifty to 
    # resolvers += Resolver.url("sbt-plugin-releases", new URL("http://scalasbt.artifactoryonline.com/scalasbt/sbt-plugin-releases/"))(Resolver.ivyStylePatterns)
    # addSbtPlugin("org.lifty" % "lifty" % "1.7.4")

fi
