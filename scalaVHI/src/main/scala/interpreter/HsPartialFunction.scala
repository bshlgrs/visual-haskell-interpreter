package interpreter

/**
 * Created by bshlegeris on 2/10/15.
 */
case class HsPartialFunction(patterns : List[HsExpr]) {
  def tryToMatch(args: List[HsExpr]): Option[Map[Name, HsExpr]] = {
    tryToMatchArg(HsConstr(Name(""), patterns), HsConstr(Name(""), args))
  }

  def tryToMatchArg(pattern: HsExpr, arg: HsExpr): Option[Map[Name, HsExpr]] = (pattern, arg) match {
    // patterns should never contain applications in themselves. (Actually, maybe that's what guards are.)
    case (HsAppl(_,_),_) => throw new Exception("this should never ever happen")
    case (HsConstr(name, args), HsConstr(name2, args2)) => {
      if (name == name2)
        None
      else if (args.length != args2.length)
        throw new Exception("type error in interpreter")
      else {
        val insideMatches: List[Option[Map[Name, HsExpr]]] = (args, args2).zipped.map(tryToMatchArg)
        if (insideMatches.forall(x => x.isDefined)) {
          Some(insideMatches.map(_.get).flatMap(_.toList).toMap)
        } else {
          None
        }
      }
    }
    case (HsConstr(_, _),_) => None
    case (HsVar(name), _) => Some(Map(name -> arg))
    case (HsInt(n), HsInt(m)) => if (n == m) Some(Map()) else None
    case (_, _) => None
  }
}
