## Giter8 template for Lift 2.4, Scala 2.9, blank, html5-ready

### Quick Start:

1.  Install [Java SDK][1] or [OpenJDK][0].
2.  Install the [Typesafe Stack][8] (or separately Scala, [sbt][3], [sbt-extras][5], [giter8][4]) \*
3.  Install Lift and this template using giter8, run it with sbt:

<div></div>

    cd ~/bin (or wherever you want giter8 to create your Lift project directory)
    g8 liftstack/lift24-s29-blank (or see [list of available Lift project templates][7])
    cd lift24-s29-blank (or whatever project name you choose from previous step)
    sbt container:start "~ compile"

Lift will be running on localhost:8080.  You can begin developing your project and SBT will automatically recompile
it on the fly as you save changes to .scala files.  Try it out by [building a multiuser chap app in about 20 lines of code][9].
    
### Explanation

giter8 (g8) downloads this Lift project template from github.  The sbt commandline:

1.  sbt =               starts sbt interactive mode.
2.  container:start =   starts the Java Servlet container specified in the Lift build.sbt file, Jetty in this case.
3.  "~ compile" =       directs sbt to [automatically recompile][10] when changes to .scala source files occur;
                        (multi-word sbt params must be in quotes when directly following 'sbt', but not
                        when run from sbt interactive prompt)

To use [Lifty][6], split up the sbt command above and insert the Lifty directive as such:

    cd ~/bin (or wherever you want giter8 to create your Lift project directory)
    g8 liftstack/lift24-s29-blank (or see [list of available Lift project templates][7])
    cd lift24-s29-blank (or whatever project name you choose from previous step)
    sbt 
    lifty learn lift https://raw.github.com/Lifty/lifty/master/lifty-recipe/lifty.json
    container:start 
    ~ compile

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
[3]:  http://github.com/harrah/xsbt/ 
[4]:  http://github.com/n8han/giter8 
[5]:  http://github.com/paulp/sbt-extras
[6]:  http://github.com/Lifty/lifty 
[7]:  http://github.com/liftstack/giter8-templates
[8]:  http://typesafe.com/stack/download 
[9]:  http://simply.liftweb.net/index-Chapter-2.html#toc-Chapter-2
[10]: https://github.com/harrah/xsbt/wiki/Triggered-Execution

