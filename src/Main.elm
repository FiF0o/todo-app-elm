module Main exposing (main)

import Html exposing (..)


type alias Todo =
    { description : String
    }


type alias Model =
    { todolist : List Todo
    }


type Msg
    = NoOp


renderTodoList : List Todo -> Html Msg
renderTodoList todolist =
    ul []
        (List.map (\todo -> li [] [ text todo.description ]) todolist)


main =
    renderTodoList [ { description = "first todo" } ]
