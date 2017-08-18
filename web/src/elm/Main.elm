module Main exposing (main)

import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Html.Events exposing (on)
import Json.Decode as Decode exposing (Value)
import Mouse exposing (Position)
import Util exposing ((=>), asset)


-- MODEL


type alias Model =
    { position : Position
    , drag : Maybe Drag
    }


type alias Drag =
    { start : Position
    , current : Position
    }


init : Value -> ( Model, Cmd Msg )
init _ =
    Model (Position 200 200) Nothing => Cmd.none



-- UPDATE


type Msg
    = DragStart Position
    | DragAt Position
    | DragEnd Position


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updateModel msg model => Cmd.none


updateModel : Msg -> Model -> Model
updateModel msg ({ position, drag } as model) =
    case msg of
        DragStart xy ->
            { model | drag = Just <| Drag xy xy }

        DragAt xy ->
            { model | drag = Maybe.map (\{ start } -> Drag start xy) drag }

        DragEnd _ ->
            { model | position = getPosition model, drag = Nothing }


getPosition : Model -> Position
getPosition { position, drag } =
    case drag of
        Nothing ->
            position

        Just { start, current } ->
            Position
                (position.x + current.x - start.x)
                (position.y + current.y - start.y)



-- VIEW


px : Int -> String
px num =
    toString num ++ "px"


view : Model -> Html Msg
view model =
    div
        []
        [ circle 200 "#d2d2d2" model
        ]


circle : Int -> String -> Model -> Html Msg
circle r color model =
    let
        realPosition =
            getPosition model

        onMouseDown_ =
            on "mousedown" (Decode.map DragStart Mouse.position)
    in
    div
        [ style
            [ "left" => px realPosition.x
            , "top" => px realPosition.y
            , "cursor" => "move"
            , "background-color" => color
            , "position" => "absolute"
            , "width" => px r
            , "height" => px r
            , "border-radius" => "50%"
            , "display" => "flex"
            , "align-items" => "center"
            , "justify-content" => "center"
            ]
        , onMouseDown_
        ]
        []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions { drag } =
    case drag of
        Nothing ->
            Sub.none

        Just _ ->
            Sub.batch
                [ Mouse.moves DragAt
                , Mouse.ups DragEnd
                ]



-- PROGRAM


main : Program Value Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
