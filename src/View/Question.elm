module View.Question exposing (..)

import Data.Question exposing (Question)
import Html exposing (Html, div, text)
import View.Button
import View.Form


view : (String -> msg) -> Question -> Html msg
view msg { question, correct, incorrect } =
    let
        answers =
            List.sort (correct :: incorrect)
    in
    div []
        [ View.Form.group [ text question ]
        , answers
            |> List.map (\x -> View.Button.btn (msg x) x)
            |> List.intersperse (text " ")
            |> View.Form.group
        ]
