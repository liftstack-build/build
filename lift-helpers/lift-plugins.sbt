
// Lift dependency
// https://github.com/lift/framework#readme
// https://github.com/liftstack/xsbt-web-plugin (use v+"-0.2.11", not 0.2.7)
libraryDependencies <+= sbtVersion(v => "com.github.siasia" %% "xsbt-web-plugin" % (v+"-0.2.11"))
