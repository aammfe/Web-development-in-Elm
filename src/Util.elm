module Util exposing (..)

import Html exposing (Attribute)
import Html.Events exposing (on, targetValue)
import Json.Decode


onChange : (String -> msg) -> Attribute msg
onChange tagger =
    on "change" (Json.Decode.map tagger targetValue)


appendIf : Bool -> a -> List a -> List a
appendIf flag value list =
    if flag then
        list ++ [ value ]

    else
        list
