module Types (..) where

type alias Answer =
  { name : String,
    images : List Image,
    kind : Kind
  }

type alias Image = 
  { url : String,
    height : Int,
    width : Int
  }

type alias Model =
  { queryParams : QueryParams
  , answers : List Answer
  }

type alias QueryParams = 
  { query : String
  , kind : Kind 
  }
  
type Kind 
  = Album
  | Track
  | Artist
  | Playlist


type Action
  = QueryChange String
  | KindChange Kind
  | Query
  | RegisterAnswers (Maybe (List Answer))
