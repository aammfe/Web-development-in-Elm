module Data.Difficulty exposing (Difficulty, default, get, isAny, keys, toString)


type Difficulty
    = Any
    | Easy
    | Medium
    | Hard


toView : Difficulty -> String
toView v =
    case v of
        Any ->
            "Any"

        Easy ->
            "Easy"

        Medium ->
            "Medium"

        Hard ->
            "Hard"


list : List ( String, Difficulty )
list =
    [ ( toView Any, Any )
    , ( toView Easy, Easy )
    , ( toView Medium, Medium )
    , ( toView Hard, Hard )
    ]


default : Difficulty
default =
    Any


keys : List String
keys =
    list |> List.unzip |> Tuple.first


get : String -> Difficulty
get key =
    list
        |> List.filter (\( k, _ ) -> k == key)
        |> List.head
        |> Maybe.map Tuple.second
        |> Maybe.withDefault default


toString : Difficulty -> String
toString lvl =
    list
        |> List.filter (\( _, v ) -> v == lvl)
        |> List.head
        |> Maybe.map Tuple.first
        |> Maybe.withDefault "Any"


isAny : Difficulty -> Bool
isAny lvl =
    lvl == Any
