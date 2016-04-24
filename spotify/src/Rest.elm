module Rest (..) where

import Effects exposing (Effects, Never)
import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing ((:=),Decoder)
import Signal exposing (message, forwardTo, Address)
import Task
import Types exposing (..)
import Debug
import String exposing (toLower)


-- unless the query string is empty initiate the search 
search : QueryParams -> Effects Action
search params =
  let 
    decoder = 
      kindToDecoder params.kind
  in
    case params.query of 
      "" -> 
        Effects.none
      _ ->  
        Http.get decoder (searchUrl params)
          |> Task.toMaybe
          |> Task.map RegisterAnswers
          |> Effects.task


searchUrl : QueryParams -> String
searchUrl queryParams =
  let 
    typeStr = String.toLower (toString queryParams.kind)
  in
    Http.url
      "https://api.spotify.com/v1/search"
      [ ( "q", queryParams.query )
      , ( "type", typeStr )
      ]


decodeImage : Decoder Image
decodeImage =
    Decode.object3 Image
        ("url" := Decode.string)
        ("height" := Decode.int)
        ("width" := Decode.int)


itemDecoder : Kind -> Decoder Answer
itemDecoder kind = 
    Decode.object3 Answer
        ("name" := Decode.string)
        ("images" := Decode.list decodeImage)
        (Decode.succeed kind)
              
              
itemsDecoder : String -> Kind -> Decoder (List Answer)
itemsDecoder key kind =
  let 
    item = itemDecoder kind
  in
    Decode.at
        [ key, "items" ]
        (Decode.list item)


kindToDecoder : Kind -> Decoder (List Answer) 
kindToDecoder kind = 
  case kind of 
    Artist -> 
      itemsDecoder "artists" Artist
    Album -> 
      itemsDecoder "albums" Album
    Playlist -> 
      itemsDecoder "playlists" Playlist
    _ -> 
      itemsDecoder "albums" Album
      
