package interpreter

/**
 * Created by bshlegeris on 2/10/15.
 */
sealed abstract class HsExpr {
  def toString() : String
  def toBracketedString() : String
  def flatten() : List[HsExpr]
}

case class HsAppl(name: Name, args: List[HsExpr]) extends HsExpr {
  override def toString() = {
    if (args.isEmpty)
      name.name
    else
      name.name ++ " " ++ args.map(_.toBracketedString()).mkString(" ")
  }

  def toBracketedString(): String = {
    if (args.isEmpty)
      toString()
    else
      "(" ++ toString() ++ ")"
  }

  def flatten() = {
    List(this) ++ args.flatMap(_.flatten())
  }
}

case class HsConstr(name: Name, args: List[HsExpr]) extends HsExpr {
  override def toString() = HsAppl(name, args).toString()
  override def toBracketedString() = HsAppl(name, args).toBracketedString()

  def flatten() = {
    List(this) ++ args.flatMap(_.flatten())
  }
}

case class HsVar(name: Name) extends HsExpr {
  override def toString() = name.name
  override def toBracketedString() = name.name

  def flatten() = List(this)
}

case class HsInt(value: Int) extends HsExpr {
  override def toString() = value.toString
  override def toBracketedString() = value.toString

  def flatten() = List(this)
}
