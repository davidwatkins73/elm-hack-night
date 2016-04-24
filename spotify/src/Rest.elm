module Rest (..) where

import Effects exposing (Effects, Never)
import Types exposing (..)
import Http
import Json.Decode as Decode exposing ((:=), Decoder)
import Task
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


imageDecoder : Decoder Image
imageDecoder =
    Decode.object3 Image
        ("url" := Decode.string)
        ("height" := Decode.int)
        ("width" := Decode.int)


itemDecoder : Kind -> Decoder Answer
itemDecoder kind = 
    Decode.object3 Answer
        ("name" := Decode.string)
        ("images" := Decode.list imageDecoder)
        (Decode.succeed kind)
              
              
itemsDecoder : String -> Kind -> Decoder (List Answer)
itemsDecoder key kind =
  let 
    item = itemDecoder kind
  in
    Decode.at
        [ key, "items" ]
        (Decode.list item)


trackDecoder : Decoder Answer
trackDecoder = 
  let
    defaultImage = Image 
        "https://i.scdn.co/image/a81ea23339529ebef5d055f19b5d5d077795405d" 
        50 
        50
  in
    Decode.object3 Answer
        ("name" := Decode.string)
        (Decode.at ["album", "images"] (Decode.list imageDecoder))
        (Decode.succeed Track)

tracksDecoder : Decoder (List Answer)
tracksDecoder =
  Decode.at 
      [ "tracks" , "items"]
      (Decode.list trackDecoder)

kindToDecoder : Kind -> Decoder (List Answer) 
kindToDecoder kind = 
  case kind of 
    Artist -> 
      itemsDecoder "artists" Artist
    Album -> 
      itemsDecoder "albums" Album
    Playlist -> 
      itemsDecoder "playlists" Playlist
    Track -> 
      tracksDecoder
      
--  "tracks" : {
