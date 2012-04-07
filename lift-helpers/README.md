## Giter8 template for Lift 2.4, Scala 2.9, blank, html5-ready

### Quick Start:

1.  Install [Java SDK][1] or [OpenJDK][0].
2.  Install the [Typesafe Stack][8] (Scala, sbt, sbt-extras, giter8) \*
3.  Install Lift and this template using giter8, run it with sbt and lifty:

<div></div>

    g8 lift-stack/lift24-s29-blank
    cd lift24-s29-blank (or whatever project name you choose from previous step)
    sbt
    lift jetty-run

Lift will be running on localhost:9000.
    
\* *Multiple install options.  For \***nix users, if you choose to install Typesafe Stack via the Typesafe repo for your distro, a required dependency is OpenJDK.  If you already have Oracle Java installed and don't want to add OpenJDK to your system via package manager required dependency, your best bet is to use the last option on the download page - the Unversal Installer (just a zipped archive you put anywhere and add the bin directory to your PATH).*

### Requires:

1.  [Java 6+][1] or [OpenJDK][0] installed
2.  [Scala 2.9][2] installed \*
3.  [sbt 0.11+][3] installed \*
4.  [sbt launcher script][5] installed and on your PATH \*
5.  [giter8][4] installed and on your PATH \*

\* #2-#5 can be easily done by installing the [Typesafe Stack][8]

### Installs:

6.  [lifty sbt plugin][6] to ~/.sbt/plugins
7.  this lift project template in the current directory


[0]:  http://openjdk.java.net/install/
[1]:  http://oracle.com/java 
[2]:  http://www.scala-lang.org/downloads 
[3]:  https://github.com/harrah/xsbt/ 
[4]:  https://github.com/n8han/giter8 
[5]:  https://github.com/paulp/sbt-extras
[6]:  https://github.com/Lifty/lifty 

[8]:  http://typesafe.com/stack/download 

