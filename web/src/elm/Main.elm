module Main exposing (main)

import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Html.Events exposing (on)
import Json.Decode as Decode exposing (Value)
import Mouse exposing (Position)
import Phoenix.Socket
import Ports
import Util exposing ((=>), asset)


-- MODEL


type alias Model =
    { position : Position
    , drag : Maybe Drag
    , phxSocket : Phoenix.Socket.Socket Msg
    }


type alias Drag =
    { start : Position
    , current : Position
    }


init : Value -> ( Model, Cmd Msg )
init _ =
    { position = Position 200 200
    , drag = Nothing
    , phxSocket = Phoenix.Socket.init "ws://10.0.0.118:4000/socket/websocket?token=SFMyNTY.g3QAAAACZAAEZGF0YW0AAAAkZGViMTAyYzMtNDA5Yi00OTA2LTgzNGQtZmZiNjdjMGNkYzQxZAAGc2lnbmVkbgYA-h1MB14B.U8RqaDxhxtx6cQkvlFaWF50VG0s2kK2kYW_3J0ur-t4"
    }
        => Cmd.none



-- UPDATE


type Msg
    = DragStart Position
    | DragAt Position
    | DragEnd Position
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveValue Value


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ position, drag } as model) =
    case msg of
        DragStart xy ->
            { model | drag = Just <| Drag xy xy }
                => Cmd.none

        DragAt xy ->
            { model | drag = Maybe.map (\{ start } -> Drag start xy) drag }
                => Cmd.none

        DragEnd _ ->
            { model | position = getPosition model, drag = Nothing }
                => Cmd.none

        PhoenixMsg msg ->
            let
                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.update msg model.phxSocket
            in
            ( { model | phxSocket = phxSocket }
            , Cmd.map PhoenixMsg phxCmd
            )

        ReceiveValue value ->
            model => Cmd.none


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
subscriptions model =
    Sub.batch
        [ mouseSubscriptions model
        , Phoenix.Socket.listen model.phxSocket PhoenixMsg
        , Ports.authenticate ReceiveValue
        ]


mouseSubscriptions : Model -> Sub Msg
mouseSubscriptions { drag } =
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
