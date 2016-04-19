module Main (..) where

import Effects exposing (Never)
import StartApp
import State
import Task exposing (Task)
import View
import Html
import Types exposing (Model)


app : StartApp.App Model
app =
  StartApp.start
    { init = State.init
    , update = State.update
    , view = View.root
    , inputs = []
    }


main : Signal Html.Html
main =
  app.html


port tasks : Signal (Task Never ())
port tasks =
  app.tasks
