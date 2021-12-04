port module Ports exposing (incoming, output)

import Data.GameResults exposing (GameResults)


port output : GameResults -> Cmd msg


port incoming : (List GameResults -> msg) -> Sub msg
