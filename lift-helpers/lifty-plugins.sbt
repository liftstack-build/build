
// Lifty = Lift scaffolding sbt plugin (http://lifty.github.com)
resolvers += Resolver.url("sbt-plugin-releases", new URL("http://scalasbt.artifactoryonline.com/scalasbt/sbt-plugin-releases/"))(Resolver.ivyStylePatterns)

// directives must be separated by blank line
addSbtPlugin("org.lifty" % "lifty" % "1.7.4")

