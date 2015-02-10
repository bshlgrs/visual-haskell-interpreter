import Data.List (intersperse)

type Name = String

data Expression = ExpApplication Name [Expression]
                | ExpConstructor Name [Expression]
                | Number Int
                | Variable Name

instance Show Expression 
    where
        show expr = case expr of
            (Application name []) -> name
            (Application name exprs) -> "(" ++ name ++ " " ++ showArguments exprs ++ ")"
            (Constructor name []) -> name
            (Constructor name exprs) -> "(" ++ name ++ " " ++ showArguments exprs ++ ")"
            (Number n) -> show n
            (Variable n) -> n

includesPred :: (Expression -> Bool) -> Expression -> Bool
includesPred pred expr = case expr of
    (Application _ exprs) = pred expr || any (includesPred pred) exprs
    (Constructor _ exprs) = pred expr || any (includesPred pred) exprs
    (Number _) = False
    (Variable _) = True

containsVariable :: Expression -> Bool
containsVariable expr = includesPred isVariable expr
    where
        isVariable (Variable _) = True
        isVariable _ = False

containsApplication :: Expression -> Bool
containsApplication expr = includesPred isApplication expr
    where
        isApplication (Application _) = True
        isApplication _ = False

fromList :: [Expression] -> Expression
fromList [] = Constructor "EmptyList" []
fromList (x:xs) = Constructor "Cons" [x, fromList xs]

data FunctionDefinition = FunctionDefinition Name [Expression] Expression

instance Show FunctionDefinition where
    show (FunctionDefinition name args expr) = name ++ 


showArguments :: (Show a) => [a] -> String
showArguments exprs = concat $ intersperse " " (map show exprs)

example = fromList [Number 1, Number 2, Number 3]