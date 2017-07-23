module Util exposing ((=>), asset, pair)


infixl 0 =>
(=>) : a -> b -> ( a, b )
(=>) =
    (,)


pair : a -> b -> ( a, b )
pair model cmd =
    model => cmd


asset : String -> String
asset =
    (++) "./assets/"
