name := "scalaVHI"

version := "1.0"

scalaVersion := "2.11.5"

libraryDependencies += "org.scalaz" %% "scalaz-core" % "7.1.1"

libraryDependencies += "be.doeraene" %%% "scalajs-jquery" % "0.8.0"

enablePlugins(ScalaJSPlugin)

name := "Scala.js Tutorial"

scalaVersion := "2.11.5"

scalaJSStage in Global := FastOptStage

