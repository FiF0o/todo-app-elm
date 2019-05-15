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
    , visibility = ViewAll
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( defaultModel, Cmd.none )


type Visibility
    = ViewAll
    | ViewCompleted
    | ViewNotCompleted


visibilityLookup : Visibility -> String
visibilityLookup visibility =
    case visibility of
        ViewAll ->
            "All"

        ViewCompleted ->
            "Completed"

        ViewNotCompleted ->
            "Not completed"


type Msg
    = Change String
    | AddTodo
    | Delete Int
    | Completed Int Bool
    | ApplyVisibilityFilters Visibility


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

        ApplyVisibilityFilters currentFilter ->
            ( { model
                | visibility = currentFilter
              }
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
    , visibility : Visibility
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


applyFilter visibilityStatus list =
    let
        isVisible todo =
            case visibilityStatus of
                ViewCompleted ->
                    todo.completed

                ViewNotCompleted ->
                    not todo.completed

                ViewAll ->
                    True
    in
    List.map (List.filter isVisible) list


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
    let
        filtersElm =
            List.map (\filter -> li [] [ a [ onClick (ApplyVisibilityFilters filter) ] [ text (visibilityLookup filter) ] ]) [ ViewAll, ViewCompleted, ViewNotCompleted ]
    in
    ul [] filtersElm


view : Model -> Html Msg
view model =
    div []
        [ renderFilters
        , label [ class "db fw6 lh-copy f6", for "new-todo" ] [ text "Your new todo" ]
        , input [ class "pa2 input-reset ba bg-transparent hover-bg-black hover-white w-100", name "new-todo", id "new-todo", value model.textField, onInput Change ] []
        , a [ class "f6 link dim ph3 pv2 mb2 dib white bg-mid-gray", href "#0", onClick AddTodo ] [ text "Add todo" ]
        , div [] [ renderTodoList <| model.todolist ]
        , div [] [ text (visibilityLookup model.visibility) ]
        ]
