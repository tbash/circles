port module Ports exposing (..)

import Json.Encode exposing (Value)


port authenticate : (Value -> msg) -> Sub msg
