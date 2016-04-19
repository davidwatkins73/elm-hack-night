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
        [ inputForm address model
        , resultsList address model
        ]
    ]


inputForm address model =
  input
    [ type' "text"
    , placeholder "Search for an album..."
    , value model.query
    , onInput address QueryChange
    , onEnter address Query
    ]
    []


resultsList address model =
  let
    toEntry answer =
      div
        [ class "col-xs-2 col-md-3" ]
        [ resultView answer ]
  in
    row (List.map toEntry model.answers)


resultView : Answer -> Html
resultView answer =
  div
    [ class "panel panel-info" ]
    [ div
        [ class "panel-heading" ]
        [ text "Album" ]
    , div
        [ class "panel-body"
        , style [ ( "height", "10rem" ) ]
        ]
        [ h4
            []
            [ text answer.name 
            , br [] []  
            , toCover answer.covers
            ]
        ]
    ]


toCover: List Cover -> Html  
toCover covers =
  let 
    cover = List.head (List.reverse covers) 
  in
    case cover of
      Just c -> 
        img
        [ src c.url
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
