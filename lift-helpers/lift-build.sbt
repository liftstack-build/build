

// https://github.com/lift/framework#readme
seq(webSettings :_*)

libraryDependencies ++= {
    val liftVersion = "2.4-M4"
    Seq(
      "net.liftweb" %% "lift-webkit" % liftVersion % "compile",
      "org.mortbay.jetty" % "jetty" % "6.1.22" % "container",
      "ch.qos.logback" % "logback-classic" % "0.9.26"
    )
}

// optional: configure sbt shell prompt to show project name
// http://sbt010.lessis.me/#48
shellPrompt := { state => 
    Project.extract(state).currentRef.project + "> " }

