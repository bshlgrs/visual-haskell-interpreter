package interpreter

/**
 * Created by bshlegeris on 2/10/15.
 */
case class HsFunctionDefinition (name: Name, patterns: List[HsPartialFunction]) {
  def getPattern(args: List[HsExpr]): Option[(HsPartialFunction, Map[Name, HsExpr])] = {
    patterns.foreach((pattern) => {
      pattern.tryToMatch(args) match {
        case Some(map) => return Some(pattern, map)
        case _ => { } // ask for a comment on this
      }
    })
    None
  }
}
