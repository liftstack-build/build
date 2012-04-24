#!/usr/bin/env bash

# Build the Lift giter8 templates.

# Requires:
#
# 1.    giter8 [1] installed and on your PATH.  Easy way get this is to use the Typesafe Stack [2].
#           [1]: http://github.com/n8han/giter8 
#           [2]: http://typesafe.com/stack/download
#
# 2.    For the default configuration, the following directory structure must be in the working directory:
# ./giter8-default                      # default giter8 project template, created by running 'g8 n8han/giter8'
# ./lift-helpers                        # code snippets, readme's, etc for dynamic insertion into templates
# ./scripts                             # this script and meta scripts for creating lift giter8 templates
# ./submodules/bootstrap                # Twitter Bootstrap, via 'git submodule add -f git://github.com/twitter/bootstrap.git', for dynamic insertion into template
# ./submodules/html5-boilerplate        # HTML Boilerplate, via 'git submodule add -f git://github.com/h5bp/html5-boilerplate.git', for dynamic insertion into template
# ./submodules/kickstrap                # Kickstrap (Bootstrap fork), via 'git submodule add -f git://github.com/ajkochanowicz/Kickstrap.git', for dynamic insertion into template
# ./submodules/lift_24_sbt              # Lift 2.4 project templates, for combination with giter8-default and other submodules
                                        #   via https://github.com/lift-stack/lift_24_sbt
# get all by cloning https://github.com/lift-stack/giter8-templates

# Usage:
# sh build-lift-giter8-project.sh
# use commandline params below to override defaults, 
#   or use meta build scripts in ./scripts that call this script with cmdline params.

# Components:
# 1.  Lift project template for Lift 2.4, Scala 2.9, modified for HTML5.  
#     ./submodules/lift_24_sbt [3]
# 2.  ./giter8 project template (created by running 'g8 n8han/giter8')
# 3.  ./lift-helpers (.gitconfig, README.md)
# [3]: https://github.com/lift-stack/lift_24_sbt

# Steps:
# TLDR - copy giter8 project template to target dir, then copy lift components and helpers into it, modify config files
# 0.  Test if target project directory exists
# 1.  copy giter8 template to new working directory ($TARGET)
# 2.  copy lift blank template to $TARGET_BUILD (eg, put lift/src in $TARGET/src/main/g8/src and lift/project in $TARGET/src/main/g8/project)
# 3.  delete lift template's sbt* files from $TARGET_BUILD (will use Typesafe Stack's sbt already installed on PATH instead)
# 4.  copy .gitignore and README.md from helpers to $TARGET, overwriting current ones
# 5.  modify config files to add HTML5, Lift, Lifty, etc.

# Configuration params
# 1=TRUE 0=FALSE (all false = lift24-s29-blank)
MVC="0"                                                 #-mvc
HTML5BP="0"                                             #-html5bp; -h5b
BOOTSTRAP="0"                                           #-bootstrap; -bs
KICKSTRAP="0"                                           #-kickstrap; -ks

# Default params
GITER8_TEMPLATE="./submodules/giter8-default"           #-g8-loc; -gl
LIFT="./submodules/lift_24_sbt"                         #-lift-loc; -ll
HELPERS="./lift-helpers"                                #-helpers-loc; -hl
TARGET="lift24-s29-blank.g8"                            #-target-loc; -tl
GITBACKUP="./submodules/gitbackup"                      #-gitbackup; -gb
TARGET_GITBACKUP="$GITBACKUP/.git.$TARGET"              #-target-gitbackup; -tgb
TARGET_BUILD="$TARGET/src/main/g8"                      #-target-build; -tb
LIFT_BOOT="$TARGET/src/main/g8/src/main/scala/bootstrap/liftweb/Boot.scala"     #lift-boot; -lb
LIFT_BOOT_PATTERN="def boot {"                          #-lift-boot-pattern; -lbp
LIFT_HTML5_SNIPPET="$HELPERS/html5-boot.scala"          #-lift-html5-snippet; -lhs
LIFT_SBT_BUILD="$TARGET_BUILD/build.sbt"                #-lift-build-sbt; -lbs
LIFT_SBT_PLUGINS="$TARGET_BUILD/project/plugins.sbt"    #-lift-plugins-sbt; -lps
LIFT_SBT_BUILD_SNIPPET="$HELPERS/lift-build.sbt"        #-lift-build-sbt-snippet; -lbss
LIFT_SBT_PLUGIN_SNIPPET="$HELPERS/lift-plugins.sbt"     #-lift-plugin-sbt-snippet; -lpss
LIFTY_SBT_BUILD_SNIPPET="$HELPERS/lifty-build.sbt"      #-lifty-build-sbt-snippet; -lybss
LIFTY_SBT_PLUGIN_SNIPPET="$HELPERS/lifty-plugins.sbt"   #-lifty-plugin-sbt-snippet; -lypss
LIFT_PROPERTIES_TEMPLATE="$HELPERS/build.properties"    #-lift-properties-template; -lpt

# Lift properties config file keys
DEFAULT_LIFT_PROPERTIES="$TARGET/src/main/g8/project/build.properties"
DEFAULT_PROJECT_ORGANIZATION="project.organization"
DEFAULT_PROJECT_NAME="project.name"
DEFAULT_SBT_VERSION="sbt.version"
DEFAULT_PROJECT_VERSION="project.version"
DEFAULT_DEF_SCALA_VERSION="def.scala.version"
DEFAULT_BUILD_SCALA_VERSIONS="build.scala.versions"
DEFAULT_PROJECT_INITIALIZE="project.initialize"
DEFAULT_LIFT_VERSION="lift.version"

# Lift properties config file values (defaults) 
LIFT_PROPERTIES="$DEFAULT_LIFT_PROPERTIES"      #-lift-properties; -lp
PROJECT_ORGANIZATION="Lift"                     #-project-org; -po
PROJECT_NAME="Lift SBT Template"                #-project-name; -pn
SBT_VERSION="0.11.2"                            #-sbt-version; -sv
PROJECT_VERSION="0.0.0"                         #-project-version; -pv
DEF_SCALA_VERSION="2.9.1"                       #-def-scala-version; -dsv
BUILD_SCALA_VERSIONS="2.9.1"                    #-build-scala-versions; -bsv
PROJECT_INITIALIZE="false"                      #-project-initialize; -pi
LIFT_VERSION="2.4"                              #-lift-version; -lv

# override above vars with any passed commandline opts (getops can't parse GNU style \
# -- long options, so both long and short denoted by single - )
while getopts "mvc:html5bp:h5b:bootstrap:bs:kickstrap:ks:g8-loc:gl:lift-loc:ll:\
    helpers-loc:hl:target-loc:tl:gitbackup:gb:target-gitbackup:tgb:target-build:tb:\
    lift-boot:lb:lift-boot-pattern:lbp:lift-html5-snippet:lhs:lift-build-sbt:lbs:\
    lift-plugins-sbt:lps:lift-build-sbt-snippet:lbss:lift-plugin-sbt-snippet:lpss:\
    lifty-build-sbt-snippet:lybss:lifty-plugin-sbt-snippet:lypss:lift-properties:lp:\
    project-org:po:project-name:pn:sbt-version:sv:project-version:pv:\
    def-scala-version:dsv:build-scala-versions:bsv:project-initialize:pi:lift-version:lv:
    lift-properties-template:lpt"\
    optionName; do
    case "$optionName" in 
        g8-loc)                     GITER8_TEMPLATE="$OPTARG";;
        gl)                         GITER8_TEMPLATE="$OPTARG";;
        lift-loc)                   LIFT="$OPTARG";;
        ll)                         LIFT="$OPTARG";;
        helpers-loc)                HELPERS="$OPTARG";;
        hl)                         HELPERS="$OPTARG";;
        target-loc)                 TARGET="$OPTARG";;
        tl)                         TARGET="$OPTARG";;
        gitbackup)                  GITBACKUP="$OPTARG";;
        gb)                         GITBACKUP="$OPTARG";;
        target-gitbackup)           TARGET_GITBACKUP="$OPTARG";;
        tgb)                        TARGET_GITBACKUP="$OPTARG";;
        target-build)               TARGET_BUILD="$OPTARG";;
        tb)                         TARGET_BUILD="$OPTARG";;
        lift-boot)                  LIFT_BOOT="$OPTARG";;
        lb)                         LIFT_BOOT="$OPTARG";;
        lift-boot-pattern)          LIFT_BOOT_PATTERN="$OPTARG";;
        lbp)                        LIFT_BOOT_PATTERN="$OPTARG";;
        lift-html5-snippet)         LIFT_HTML5_SNIPPET="$OPTARG";;
        lhs)                        LIFT_HTML5_SNIPPET="$OPTARG";;
        lift-properties)            LIFT_PROPERTIES="$OPTARG";;
        lp)                         LIFT_PROPERTIES="$OPTARG";;
        lift-sbt-build)             LIFT_SBT_BUILD="$OPTARG";;
        lsb)                        LIFT_SBT_BUILD="$OPTARG";;
        lift-sbt-plugins)           LIFT_SBT_PLUGINS="$OPTARG";;
        lsp)                        LIFT_SBT_PLUGINS="$OPTARG";;
        lift-build-sbt-snippet)     LIFT_SBT_BUILD_SNIPPET="$OPTARG";;
        lbss)                       LIFT_SBT_BUILD_SNIPPET="$OPTARG";;
        lift-plugin-sbt-snippet)    LIFT_SBT_PLUGIN_SNIPPET="$OPTARG";;
        lpss)                       LIFT_SBT_PLUGIN_SNIPPET="$OPTARG";;
        lifty-sbt-build)            LIFTY_SBT_BUILD_SNIPPET="$OPTARG";;
        lysb)                       LIFTY_SBT_BUILD_SNIPPET="$OPTARG";;
        lifty-sbt-plugins)          LIFTY_SBT_PLUGIN_SNIPPET="$OPTARG";;
        lysp)                       LIFTY_SBT_PLUGIN_SNIPPET="$OPTARG";;
        mvc)                        MVC="0";;
        html5bp)                    HTML5BP="0";;
        h5b)                        HTML5BP="0";;
        bootstrap)                  BOOTSTRAP="0";;
        bs)                         BOOTSTRAP="0";;
        kickstrap)                  KICKSTRAP="0";;
        ks)                         KICKSTRAP="0";;
        project-org)                PROJECT_ORGANIZATION="$OPTARG";;
        po)                         PROJECT_ORGANIZATION="$OPTARG";;
        project-name)               PROJECT_NAME="$OPTARG";;
        pn)                         PROJECT_NAME="$OPTARG";;
        sbt-version)                SBT_VERSION="$OPTARG";;
        sv)                         SBT_VERSION="$OPTARG";;
        project-version)            PROJECT_VERSION="$OPTARG";;
        pv)                         PROJECT_VERSION="$OPTARG";;
        def-scala-version)          DEF_SCALA_VERSION="$OPTARG";;
        dsv)                        DEF_SCALA_VERSION="$OPTARG";;
        build-scala-versions)       BUILD_SCALA_VERSIONS="$OPTARG";;
        bsv)                        BUILD_SCALA_VERSIONS="$OPTARG";;
        project-initialize)         PROJECT_INITIALIZE="$OPTARG";;
        pi)                         PROJECT_INITIALIZE="$OPTARG";;
        lift-version)               LIFT_VERSION="$OPTARG";;
        lv)                         LIFT_VERSION="$OPTARG";;
        lift-propteries-template)   LIFT_PROPERTIES_TEMPLAT="$OPTARG";;
        lpt)                        LIFT_PROPERTIES_TEMPLAT="$OPTARG";;  
        [?]) printErrorHelpAndExit "$badOptionHelp";;
    esac
done

# output build params; TODO: add last chance modify/abort option
echo "Building with:"
echo "GITER8_TEMPLATE:              $GITER8_TEMPLATE"
echo "LIFT:                         $LIFT"     
echo "HELPERS:                      $HELPERS" 
echo "TARGET:                       $TARGET" 
echo "TARGET_GITBACKUP:             $TARGET_GITBACKUP"
echo "TARGET_BUILD:                 $TARGET_BUILD"
echo "LIFT_BOOT:                    $LIFT_BOOT" 
echo "LIFT_BOOT_PATTERN:            $LIFT_BOOT_PATTERN"
echo "LIFT_HTML5_SNIPPET:           $LIFT_HTML5_SNIPPET"
echo "LIFT_PROPERTIES_TEMPLATE:     $LIFT_PROPERTIES_TEMPLATE"
echo "LIFT_PROPERTIES:              $LIFT_PROPERTIES"
echo "$DEFAULT_PROJECT_ORGANIZATION:        $PROJECT_ORGANIZATION"
echo "$DEFAULT_PROJECT_NAME:                $PROJECT_NAME"
echo "$DEFAULT_SBT_VERSION:                 $SBT_VERSION"
echo "$DEFAULT_PROJECT_VERSION:             $PROJECT_VERSION"
echo "$DEFAULT_DEF_SCALA_VERSION:           $DEF_SCALA_VERSION"
echo "$DEFAULT_BUILD_SCALA_VERSIONS:        $BUILD_SCALA_VERSIONS"
echo "$DEFAULT_PROJECT_INITIALIZE:          $PROJECT_INITIALIZE"
echo "$DEFAULT_LIFT_VERSION:                $LIFT_VERSION"
echo "LIFT_SBT_BUILD:               $LIFT_SBT_BUILD"
echo "LIFT_SBT_PLUGINS:             $LIFT_SBT_PLUGINS"
echo "LIFT_SBT_BUILD_SNIPPET:       $LIFT_SBT_BUILD_SNIPPET"
echo "LIFT_SBT_PLUGIN_SNIPPET:      $LIFT_SBT_PLUGIN_SNIPPET"
echo "LIFTY_SBT_BUILD_SNIPPET:      $LIFTY_SBT_BUILD_SNIPPET"
echo "LIFTY_SBT_PLUGIN_SNIPPET:     $LIFTY_SBT_PLUGIN_SNIPPET"
echo "MVC:                          $MVC"
echo "HTML5BP:                      $HTML5BP"
echo "BOOTSTRAP:                    $BOOTSTRAP"
echo "KICKSTRAP:                    $KICKSTRAP"

# Main
if [ -d "$TARGET" ]; then 
    if [ -L "$TARGET" ]; then
        # Target dir exists and is a symlink.
        # Symbolic link specific commands go here
        #rm "$TARGET"
        echo "$TARGET exists.  It's a symlink.  No overwrite possible for data security.  Please manually remove it, rename it, or change your TARGET name."
        echo "Aborting..."
    else
        # Target dir exists and is a directory.
        # Directory command goes here
        #rmdir "$TARGET"
        echo "$TARGET exists.  It's a directory.  No overwrite possible for data security.  Please remove it, rename it, or change your TARGET name."
        echo "Aborting..."
    fi
else

    # TODO: provide option to overwrite existing target dir - all files and folders except $TARGET/.git
    # TODO: make this whole section a transaction, don't commit if any part fails
    
    # View-first (default) or MVC?
    # If MVC=0 (default)
    #   IF html5bp + kickstrap
    #       change $TARGET to ./lift24-s29-html5bp-kickstrap.g8
    #   IF html5bp + bootstrap
    #       change $TARGET to ./lift24-s29-html5bp-bootstrap.g8
    #   IF html5bp only
    #       change $TARGET to ./lift24-s29-html5bp.g8
    #   IF mvc only
    #       change $TARGET to ./lift24-s29-blank.g8
    # Else:
    #   set $LIFT to ./submodules/lift_24_sbt/scala29/lift_mvc
    #   IF html5bp + kickstrap
    #       change $TARGET to ./lift24-s29-mvc-html5bp-kickstrap.g8
    #   IF html5bp + bootstrap
    #       change $TARGET to ./lift24-s29-mvc-html5bp-bootstrap.g8
    #   IF html5bp only
    #       change $TARGET to ./lift24-s29-mvc-html5bp.g8
    #   IF mvc only
    #       change $TARGET to ./lift24-s29-mvc-blank.g8
    
    # Target dir does not exist, proceed with build:
    mkdir -p $TARGET
    cp -r $GITER8_TEMPLATE/* $TARGET
    rm -rf $TARGET/src/main/g8/src/*
    cp -r $LIFT/* $TARGET/src/main/g8/
    rm -rf $TARGET/src/main/g8/sbt*
    #cp -r $LIFT/src/* $TARGET/src/main/g8/src
    #cp -r $LIFT/project/ $TARGET/src/main/g8/
    cp -r $HELPERS/README.md $TARGET
    [ ! -e $TARGET/.gitignore ] || rm -rf $TARGET/.gitignore
    cp -r $HELPERS/.gitignore $TARGET
    cp -r $TARGET_GITBACKUP/ $TARGET/.git
    rm -rf $TARGET/vim~
    rm -rf $TARGET/src/main/g8/vim~
    rm -rf $TARGET/src/main/g8/project/vim~
    rm -rf $TARGET/src/main/g8/src/main/scala/code/snippet/vim~
    rm -rf $TARGET/src/main/g8/src/main/scala/bootstrap/liftweb/vim~

    # add Lift and Lifty to $TARGET_BUILD/project/plugins.sbt
    if [ ! -e "$LIFT_SBT_PLUGINS" ]; then 
        touch $LIFT_SBT_PLUGINS;
    fi
    #cat $LIFT_SBT_PLUGIN_SNIPPET >> $LIFT_SBT_PLUGINS
    cat $LIFTY_SBT_PLUGIN_SNIPPET >> $LIFT_SBT_PLUGINS

    # add Lift and Lifty to $TARGET_BUILD/build.sbt
    if [ ! -e "$LIFT_SBT_BUILD" ]; then 
        touch $LIFT_SBT_BUILD;
    fi
    # not needed with lift template https://github.com/d6y/lift_24_sbt
    #cat $LIFT_SBT_BUILD_SNIPPET >> $LIFT_SBT_BUILD
    #cat $LIFTY_SBT_BUILD_SNIPPET >> $LIFT_SBT_BUILD

    # inject html5 enabler snippet into Boot.scala after: def boot {
    # not necessary with template https://github.com/d6y/lift_24_sbt
    #sed -i "/$LIFT_BOOT_PATTERN/r $LIFT_HTML5_SNIPPET" $LIFT_BOOT
    
    # update Lift project build.properties
    if [ -e "$LIFT_PROPERTIES" ]; then
        rm -rf $LIFT_PROPERTIES;
        cp $LIFT_PROPERTIES_TEMPLATE $LIFT_PROPERTIES;
    else
        cp $LIFT_PROPERTIES_TEMPLATE $LIFT_PROPERTIES;
    fi
    sed -i "s/$DEFAULT_PROJECT_ORGANIZATION=.*/$DEFAULT_PROJECT_ORGANIZATION=$PROJECT_ORGANIZATION/" $LIFT_PROPERTIES
    sed -i "s/$DEFAULT_PROJECT_NAME=.*/$DEFAULT_PROJECT_NAME=$PROJECT_NAME/" $LIFT_PROPERTIES
    sed -i "s/$DEFAULT_SBT_VERSION=.*/$DEFAULT_SBT_VERSION=$SBT_VERSION/" $LIFT_PROPERTIES
    sed -i "s/$DEFAULT_PROJECT_VERSION=.*/$DEFAULT_PROJECT_VERSION=$PROJECT_VERSION/" $LIFT_PROPERTIES
    sed -i "s/$DEFAULT_DEF_SCALA_VERSION=.*/$DEFAULT_DEF_SCALA_VERSION=$DEF_SCALA_VERSION/" $LIFT_PROPERTIES
    sed -i "s/$DEFAULT_BUILD_SCALA_VERSIONS=.*/$DEFAULT_BUILD_SCALA_VERSIONS=$BUILD_SCALA_VERSIONS/" $LIFT_PROPERTIES
    sed -i "s/$DEFAULT_PROJECT_INITIALIZE=.*/$DEFAULT_PROJECT_INITIALIZE=$PROJECT_INITIALIZE/" $LIFT_PROPERTIES
    sed -i "s/$DEFAULT_LIFT_VERSION=.*/$DEFAULT_LIFT_VERSION=$LIFT_VERSION/" $LIFT_PROPERTIES
    
    # html5bp!=0, bootstrap!=0, or kickstrap!=0, add component to $TARGET_BUILD

fi
