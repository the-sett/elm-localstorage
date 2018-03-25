----------------------------------------------------------------------
--
-- SharedTypes.elm
-- Shared types for LocalStorage module.
-- Copyright (c) 2018 Bill St. Clair <billstclair@gmail.com>
-- Some rights reserved.
-- Distributed under the MIT License
-- See LICENSE.txt
--
----------------------------------------------------------------------


module LocalStorage.SharedTypes
    exposing
        ( ClearPort
        , DictState
        , GetItemPort
        , Key
        , Operation(..)
        , Ports(..)
        , ReceiveItemPort
        , SetItemPort
        , Value
        , emptyDictState
        )

{-| Types for the `LocalStorage` module.


# Types

@docs Key, Value, Operation, Ports, DictState


# Port Signatures

@docs GetItemPort, SetItemPort, ClearPort, ReceiveItemPort


# Constants

@docs emptyDictState

-}

import Dict exposing (Dict)
import Json.Encode


{-| A convenience type for keys in the store. Same as `String`.
-}
type alias Key =
    String


{-| A convenience type for values in the store. Same as `Json.Encode.Value`.
-}
type alias Value =
    Json.Encode.Value


{-| A `Dict` that stores key/value pairs for the simulated ports.
-}
type alias DictState =
    Dict Key Value


{-| `Dict.empty`
-}
emptyDictState : DictState
emptyDictState =
    Dict.empty


{-| The operation that caused your wrapper `Msg` to be sent.

For real ports, you'll only ever see GetItemOperation.

For simluated ports, you'll see the others as well, because you have to save the updated state.

-}
type Operation
    = GetItemOperation
    | SetItemOperation
    | ClearOperation


{-| The required signature of your `localStorage.getItem` port.
-}
type alias GetItemPort msg =
    Key -> Cmd msg


{-| The required signature of your `localStorage.setItem` port.
-}
type alias SetItemPort msg =
    ( Key, Value ) -> Cmd msg


{-| The required signature of your `localStorage.clear` port.
-}
type alias ClearPort msg =
    String -> Cmd msg


{-| The required signature of your subscription to receive `getItem` values.
-}
type alias ReceiveItemPort msg =
    (( Key, Value ) -> msg) -> Sub msg


{-| Wrap up your ports.

You'll usually create one of these with `LocalStorage.realRealPorts` or `DictPorts.make`.

Your update Msg will receive one, if you're using simulated ports.

-}
type Ports msg
    = Ports
        { getItem : Ports msg -> GetItemPort msg
        , setItem : Ports msg -> SetItemPort msg
        , clear : Ports msg -> ClearPort msg
        , state : DictState
        }
