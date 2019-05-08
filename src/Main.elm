module Main exposing (main)

import Browser
import Html exposing (..)


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : Model -> ( Model, Cmd Msg )
init model =
    ( { todolist = [ { description = "description 1" } ] }, Cmd.none )


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


type alias Todo =
    { description : String
    }


type alias Model =
    { todolist : List Todo
    }


renderTodoList : List Todo -> Html Msg
renderTodoList list =
    ul []
        (List.map (\todo -> li [] [ text todo.description ]) list)


view : Model -> Html Msg
view model =
    case model of
        todoList ->
            div []
                [ renderTodoList model.todolist
                ]
