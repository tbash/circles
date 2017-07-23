module Main exposing (main)

import Html exposing (Html, div, img, text)
import Html.Attributes exposing (class, src)
import Util exposing ((=>), asset)


-- MODEL


type alias Model =
    { isLoading : Bool
    }


init : ( Model, Cmd Msg )
init =
    Model False => Cmd.none



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        _ ->
            model => Cmd.none



-- VIEW


view : Model -> Html msg
view model =
    div [ class "some" ]
        [ img [ src <| asset "logo.svg" ] []
        , text "hey"
        ]



-- PROGRAM


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        }
