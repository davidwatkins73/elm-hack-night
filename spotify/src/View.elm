module View (root) where

import Events exposing (onInput, onEnter)
import Html exposing (..)
import Html.Attributes exposing (..)
import Signal exposing (message, forwardTo, Address)
import Types exposing (..)
import Debug

root : Signal.Address Action -> Model -> Html
root address model =
  div
    [ style [ ( "margin", "20px 0" ) ] ]
    [ bootstrap
    , containerFluid
        [ inputForm address model.queryParams
        , resultsList address model.answers
        ]
    ]


inputForm address queryParams =
  input
    [ type' "text"
    , placeholder "Search..."
    , value queryParams.query
    , onInput address QueryChange
    , onEnter address Query
    ]
    []


resultsList address answers =
  let
    toEntry answer =
      div
        [ class "col-xs-2 col-md-3" ]
        [ resultView answer ]
  in
    row (List.map toEntry answers)


resultView : Answer -> Html
resultView answer =
  div
    [ class "panel panel-info" ]
    [ div
        [ class "panel-heading" ]
        [ text (toString answer.kind) ]
    , div
        [ class "panel-body"
        , style [ ( "height", "11rem" ) ]
        ]
        [ h5
            []
            [ text answer.name 
            , br [] []  
            , toImage answer.images
            ]
        ]
    ]


toImage: List Image -> Html  
toImage images =
  let 
    image = List.head (List.reverse images) 
  in
    case image of
      Just i -> 
        img
        [ src i.url
        , height 50
        , width 50
        ]
        []
      Nothing ->
        text "Nothing"
  
       
-- Bootstrap.


containerFluid =
  div [ class "container-fluid" ]


row =
  div [ class "row" ]


bootstrap =
  node
    "link"
    [ href "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
    , rel "stylesheet"
    ]
    []
