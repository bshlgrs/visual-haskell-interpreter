import Data.List (intersperse)
import qualified Data.Map as M
import Data.Maybe

type Name = String

data Expression = Application Name [Expression]
                | Constructor Name [Expression]
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
            where       
                showArguments :: (Show a) => [a] -> String
                showArguments exprs = concat $ intersperse " " (map show exprs)

includesPred :: (Expression -> Bool) -> Expression -> Bool
includesPred pred expr = case expr of
    (Application _ exprs) -> pred expr || any (includesPred pred) exprs
    (Constructor _ exprs) -> pred expr || any (includesPred pred) exprs
    (Number _) -> False
    (Variable _) -> True

containsVariable :: Expression -> Bool
containsVariable expr = includesPred isVariable expr
    where
        isVariable (Variable _) = True
        isVariable _ = False

containsApplication :: Expression -> Bool
containsApplication expr = includesPred isApplication expr
    where
        isApplication (Application _ _) = True
        isApplication _ = False

fromList :: [Expression] -> Expression
fromList [] = Constructor "EmptyList" []
fromList (x:xs) = Constructor "Cons" [x, fromList xs]

data FunctionDefinition = FunctionDefinition Name [(ArgumentList, Expression)]

instance Show FunctionDefinition where
    show (FunctionDefinition name patterns) = concat $ intersperse "\n" (map (showPattern name) patterns)
        where
            showPattern name pattern = name ++ " = " ++ show pattern

type ArgumentList = [Expression]

example = fromList [Number 1, Number 2, Number 3]

patternMatchArgs :: Expression -> Expression -> Maybe [(Name, Expression)]
patternMatchArgs pattern arg = case (pattern, arg) of
    (Application _ _, _) -> error "fuck, there was an application in the pattern"
    (Constructor name arg, Constructor name2 arg2)
        | name == name2 && all isJust matches -> Just $ concat $ catMaybes matches
        | otherwise -> Nothing
            where matches = zipWith patternMatchArgs arg arg2
    (Variable name, exp) -> Just [(name, exp)]
    (Number n, Number m)
        | n == m -> Just []
        | otherwise -> Nothing

patternMatch :: ArgumentList -> [Expression] -> Maybe [(Name, Expression)]
patternMatch patterns args
    | all isJust matches = Just $ concat $ catMaybes matches
    | otherwise = Nothing
        where matches = zipWith patternMatchArgs patterns args

