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
    = Change String
    | AddTodo


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change textInputValue ->
            ( { model | textField = textInputValue }, Cmd.none )

        AddTodo ->
            ( { model
                | todolist =
                    if String.isEmpty model.textField then
                        model.todolist

                    else
                        model.todolist ++ [ addTodo model.textField ]
              }
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
    , textField : String
    }


addTodo : String -> Todo
addTodo todoText =
    { description = todoText
    }


renderTodoList : List Todo -> Html Msg
renderTodoList list =
    ul []
        (List.map (\todo -> li [] [ text todo.description ]) list)


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "new to do", value model.textField, onInput Change ] []
        , button [ onClick AddTodo ] [ text "add to do" ]
        , div [] [ renderTodoList model.todolist ]
        ]
