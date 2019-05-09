module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- We init our model with a todolist containing some dummy data


defaultModel : Model
defaultModel =
    { todolist = [ { description = "Hello" } ]
    , textField = ""
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( defaultModel, Cmd.none )


type Msg
    = NoOp
    | Change String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Cmd.none
            )

        Change textInputValue ->
            ( { model | textField = textInputValue }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


type alias Todo =
    { description : String
    }


type alias Model =
    { todolist : List Todo
    , textField : String
    }


renderTodoList : List Todo -> Html Msg
renderTodoList list =
    ul []
        (List.map (\todo -> li [] [ text todo.description ]) list)


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "new to do", value model.textField, onInput Change ] []
        , button [] []
        , p [] [ text <| model.textField ]
        , div [] [ renderTodoList model.todolist ]
        ]
