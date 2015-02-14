package web_stuff

import org.scalajs.dom
import dom.document

import interpreter._

/**
 * Created by bshlegeris on 2/13/15.
 */

import scala.scalajs.js.JSApp



object TutorialApp extends JSApp {
  def appendPar(targetNode: dom.Node, text: String): Unit = {
    val parNode = document.createElement("p")
    val textNode = document.createTextNode(text)
    parNode.appendChild(textNode)
    targetNode.appendChild(parNode)
  }

  def main(): Unit = {
    appendPar(document.body, "Hello World")
  }
}
