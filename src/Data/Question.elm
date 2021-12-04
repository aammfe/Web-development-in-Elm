module Data.Question exposing (Question, decoder)

import Json.Decode exposing (Decoder, field, list, map3, string)


type alias Question =
    { userAnswer : Maybe String
    , question : String
    , correct : String
    , incorrect : List String
    }


decoder : Decoder Question
decoder =
    map3 (Question Nothing)
        (field "question" string)
        (field "correct_answer" string)
        (field "incorrect_answers" (list string))
