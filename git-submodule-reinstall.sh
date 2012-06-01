#!/usr/bin/env bash -

#: << '--COMMENT--'
git submodule add git@github.com:liftstack/320andup.git submodules/320andup
git submodule add git@github.com:liftstack/foundation.git submodules/foundation
git submodule add git@github.com:liftstack/gitbackup.git submodules/gitbackup
git submodule add git@github.com:liftstack/giter8-default.git submodules/giter8-default
git submodule add git@github.com:liftstack/html5-boilerplate submodules/html5-boilerplate
git submodule add git@github.com:liftstack/html5bp-bootstrap-initializr submodules/html5bp-bootstrap-initializr
git submodule add git@github.com:liftstack/Kickstrap.git submodules/kickstrap
git submodule add git@github.com:liftstack/lift_24_sbt.git submodules/lift_24_sbt
git submodule add git@github.com:liftstack/lift_24_sbt_d6y.git submodules/lift_24_sbt_d6y
git submodule add git@github.com:liftstack/lift-quickstart.git submodules/lift-quickstart

cd ~/bin/projects/lift/liftstack/build/submodules/320andup
git remote add upstream git://github.com/malarkey/320andup.git
cd ~/bin/projects/lift/liftstack/build/submodules/foundation
git remote add upstream git://github.com/zurb/foundation.git
cd ~/bin/projects/lift/liftstack/build/submodules/html5-boilerplate
git remote add upstream git://github.com/h5bp/html5-boilerplate.git
cd ~/bin/projects/lift/liftstack/build/submodules/kickstrap
git remote add upstream git://github.com/ajkochanowicz/Kickstrap.git
cd ~/bin/projects/lift/liftstack/build/submodules/lift_24_sbt
git remote add upstream git://github.com/lift/lift_24_sbt.git
cd ~/bin/projects/lift/liftstack/build/submodules/lift_24_sbt_d6y
git remote add upstream git://github.com/lift/lift_24_sbt_d6y.git
cd ~/bin/projects/lift/liftstack/build/submodules/lift-quickstart
git remote add upstream git://github.com/viktortnk/lift-quickstart.git
#--COMMENT-- 
