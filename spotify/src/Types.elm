module Types (..) where


type alias Answer =
  { name : String,
    covers : List Cover
  }

type alias Cover = 
  { url : String,
    height : Int,
    width : Int
  }

type alias Model =
  { query : String
  , answers : List Answer
  }


type Action
  = QueryChange String
  | Query
  | RegisterAnswers (Maybe (List Answer))
