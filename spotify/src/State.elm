module State (..) where

import Effects exposing (Effects, Never)
import Events exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json exposing ((:=))
import Signal exposing (message, forwardTo, Address)
import Task
import Types exposing (..)
import Rest


init : ( Model, Effects Action )
init =
  ( { queryParams = 
      { query = ""
      , kind = Album
      }
    , answers = []
    }
  , Effects.none
  )


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    QueryChange q ->
      ( { model | queryParams = updateQuery q model.queryParams }
      , Effects.none
      )
        
    KindChange k -> 
      ( { model | queryParams = updateKind k model.queryParams }
      , Effects.none
      )
  
    Query ->
      ( model
      , Rest.search model.queryParams
      )

    RegisterAnswers maybeAnswers ->
      ( { model | answers = (Maybe.withDefault [] maybeAnswers) }
      , Effects.none
      )

updateKind : Kind -> QueryParams -> QueryParams
updateKind k p = { p | kind = k }

updateQuery : String -> QueryParams -> QueryParams
updateQuery q p = { p | query = q }