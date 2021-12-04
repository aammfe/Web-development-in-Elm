module Request.TriviaQuestions exposing (..)

import Data.Question exposing (Question)
import Json.Decode exposing (Decoder, field, int, list, map2)


apiUrl : String -> String
apiUrl str =
    "https://opentdb.com/api.php" ++ str


type alias TriviaResults =
    { code : Int
    , questions : List Question
    }


decoder : Decoder TriviaResults
decoder =
    map2 TriviaResults
        (field "response_code" int)
        (field "results" (list Data.Question.decoder))
