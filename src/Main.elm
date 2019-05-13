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
    { todolist = []
    , textField = ""
    , uid = 0
    , visibility = "All"
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( defaultModel, Cmd.none )


type Msg
    = Change String
    | AddTodo
    | Delete Int
    | ApplyFilter String
    | Completed Int Bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change textInputValue ->
            ( { model | textField = textInputValue }, Cmd.none )

        AddTodo ->
            ( { model
                | textField = ""
                , uid = model.uid + 1
                , todolist =
                    if String.isEmpty model.textField then
                        model.todolist

                    else
                        model.todolist ++ [ addTodo model.textField model.uid ]
              }
            , Cmd.none
            )

        Delete todoId ->
            ( { model | todolist = filterTodoList model.todolist todoId }, Cmd.none )

        ApplyFilter filter ->
            ( { model | visibility = filter }, Cmd.none )

        Completed id isCompleted ->
            let
                updateTodo todo =
                    if todo.id == id then
                        { todo | completed = isCompleted }

                    else
                        todo
            in
            ( { model | todolist = List.map updateTodo model.todolist }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


type alias Todo =
    { description : String
    , id : Int
    , completed : Bool
    }


type alias Model =
    { todolist : List Todo
    , textField : String
    , uid : Int
    , visibility : String
    }


addTodo : String -> Int -> Todo
addTodo todoText todoId =
    { description = todoText
    , id = todoId
    , completed = False
    }


filterTodoList : List Todo -> Int -> List Todo
filterTodoList list todoId =
    List.filter (\todo -> todo.id /= todoId) list


renderTodoList : List Todo -> Html Msg
renderTodoList list =
    ul []
        (List.map
            (\todo ->
                li
                    [ id ("todo-" ++ String.fromInt todo.id)
                    , class
                        (if todo.completed then
                            "completed"

                         else
                            "not-completed"
                        )
                    ]
                    [ p [ onDoubleClick (Completed todo.id (not todo.completed)) ] [ text todo.description ]
                    , button [ onClick (Delete todo.id) ]
                        [ text "delete todo" ]
                    ]
            )
            list
        )


renderFilters : Html Msg
renderFilters =
    ul []
        (List.map (\txt -> li [] [ a [ onClick (ApplyFilter txt) ] [ text txt ] ]) [ "All", "Completed", "Not completed" ])


view : Model -> Html Msg
view model =
    div []
        [ renderFilters
        , label [ class "db fw6 lh-copy f6", for "new-todo" ] [ text "Your new todo" ]
        , input [ class "pa2 input-reset ba bg-transparent hover-bg-black hover-white w-100", name "new-todo", id "new-todo", value model.textField, onInput Change ] []
        , a [ class "f6 link dim ph3 pv2 mb2 dib white bg-mid-gray", href "#0", onClick AddTodo ] [ text "Add todo" ]
        , div [] [ renderTodoList model.todolist ]
        ]
