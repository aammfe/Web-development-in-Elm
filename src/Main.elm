module Main exposing (..)

import Array exposing (Array)
import Browser
import Data.Difficulty exposing (Difficulty)
import Data.GameResults exposing (GameResults)
import Data.Question exposing (Question)
import Html exposing (div, input, option, select, text)
import Html.Attributes exposing (value)
import Http exposing (Error)
import Platform.Cmd exposing (Cmd)
import Ports exposing (incoming, output)
import Request.Helpers exposing (queryString)
import Request.TriviaQuestions exposing (TriviaResults)
import Util exposing (appendIf, onChange)
import View.Button
import View.Question


type alias Flags =
    Int


type alias Model =
    { amount : Int
    , difficulty : Data.Difficulty.Difficulty
    , questions : Array Question
    }


init : Flags -> ( Model, Cmd Message )
init flags =
    let
        model =
            Model flags Data.Difficulty.default Array.empty
    in
    ( model, Cmd.none )


type Message
    = Answer Int String
    | UpdateAmount String
    | ChangeDifficulty Difficulty
    | Start
    | GetQuestions (Result Error TriviaResults)
    | SubmitAnswers
    | SavedGameResults (List GameResults)


update : Message -> Model -> ( Model, Cmd Message )
update msg model =
    case Debug.log "MSG: " msg of
        Answer i val ->
            answer model i val

        UpdateAmount str ->
            updateAmount model str

        ChangeDifficulty lvl ->
            ( { model | difficulty = lvl }, Cmd.none )

        Start ->
            start model

        GetQuestions res ->
            getQuestions model res

        SubmitAnswers ->
            submitAnswers model

        SavedGameResults _ ->
            ( model, Cmd.none )


submitAnswers : Model -> ( Model, Cmd Message )
submitAnswers model =
    let
        length =
            Array.length model.questions

        score =
            Array.foldl
                (\{ userAnswer, correct } acc ->
                    case userAnswer of
                        Just v ->
                            if v == correct then
                                acc + 1

                            else
                                acc

                        Nothing ->
                            acc
                )
                0
                model.questions

        res =
            GameResults score length
    in
    ( model, output res )


getQuestions : Model -> Result Error TriviaResults -> ( Model, Cmd Message )
getQuestions model res =
    let
        updated =
            case res of
                Ok { questions } ->
                    { model | questions = Array.fromList questions }

                Err _ ->
                    model
    in
    ( updated, Cmd.none )


start : Model -> ( Model, Cmd Message )
start model =
    let
        difficultyValue =
            model.difficulty |> Data.Difficulty.toString |> String.toLower

        isAny =
            Data.Difficulty.isAny model.difficulty

        queryParams =
            [ ( "amount", String.fromInt model.amount ) ]
                |> appendIf (not isAny) ( "difficulty", difficultyValue )
                |> queryString

        url =
            Request.TriviaQuestions.apiUrl queryParams

        expect =
            Http.expectJson GetQuestions Request.TriviaQuestions.decoder

        cmd =
            Http.get { url = url, expect = expect }
    in
    ( model, cmd )


answer : Model -> Int -> String -> ( Model, Cmd Message )
answer model i val =
    let
        updated =
            model.questions
                |> Array.get i
                |> Maybe.map (\q -> { q | userAnswer = Just val })
                |> Maybe.map (\q -> Array.set i q model.questions)
                |> Maybe.map (\arr -> { model | questions = arr })
                |> Maybe.withDefault model
    in
    ( updated, Cmd.none )


updateAmount : Model -> String -> ( Model, Cmd Message )
updateAmount model str =
    let
        updated =
            case String.toInt str of
                Just val ->
                    if val > 50 then
                        { model | amount = 50 }

                    else
                        { model | amount = val }

                _ ->
                    model
    in
    ( updated, Cmd.none )


view : Model -> Html.Html Message
view { amount, questions } =
    div []
        [ input
            [ onChange UpdateAmount
            , value (String.fromInt amount)
            ]
            []
        , select [ onChange (ChangeDifficulty << Data.Difficulty.get) ]
            (List.map (\k -> option [] [ text k ]) Data.Difficulty.keys)
        , View.Button.btn Start "Start"
        , div []
            (questions
                |> Array.indexedMap (\i q -> View.Question.view (Answer i) q)
                |> Array.toList
            )
        , View.Button.btn SubmitAnswers "Submit"
        ]


subscriptions : Model -> Sub Message
subscriptions _ =
    incoming SavedGameResults


main : Program Flags Model Message
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
