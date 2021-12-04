module Request.Helpers exposing (..)


queryString list =
    list
        |> List.map (\( a, b ) -> a ++ "=" ++ b)
        |> String.join "&"
        |> (++) "?"
