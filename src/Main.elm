import Html exposing (..)
import Html.App exposing (beginnerProgram)
import Html.Events exposing (onClick)


main =
  beginnerProgram {
    model = init 6
  , view = view
  , update = update
  }


-- MODEL


type alias Model =
  { permutation: List Int }


init : Int -> Model
init n =
  {
    permutation = range n
  }


range : Int -> List Int
range n =
  sequence 0 n


sequence : Int -> Int -> List Int
sequence a b =
  if a >= b then
     []
  else
    [a] ++ sequence (a + 1) b


rotate : List a -> List a
rotate permutation =
  case permutation of
    [] ->
      []

    x :: xs ->
      xs ++ [x]


inverseRotate : List a -> List a
inverseRotate permutation =
  permutation |> reverse |> rotate |> reverse

swapFirst : List a -> List a
swapFirst permutation =
  let
    parts =
      equalize ([], permutation)

    first =
      fst parts

    second =
      snd parts
  in
    (reverse first) ++ second


reverse : List a -> List a
reverse permutation =
  case permutation of
    [] ->
      []

    x :: xs ->
      (reverse xs) ++ [x]


split : List a -> (List a, List a)
split permutation =
  equalize ([], permutation)


equalize : (List a, List a) -> (List a, List a)
equalize (xs, ys) =
  if (List.length xs >= List.length ys) then
    (xs, ys)
  else
    case ys of
      [] ->
        (xs, ys)

      z :: zs ->
        equalize (xs ++ [z], zs)


-- UPDATE


type Message =
  Rotate
  | InverseRotate
  | Swap


update : Message -> Model -> Model
update msg model =
  case msg of
    Rotate ->
      { model | permutation = rotate model.permutation }

    InverseRotate ->
      { model | permutation = inverseRotate model.permutation }

    Swap ->
      { model | permutation = swapFirst model.permutation }


-- VIEW


view : Model -> Html Message
view model =
  let
    rotate =
      button [ onClick Rotate ] [ text "r" ]

    inverse =
      button [ onClick InverseRotate ] [ text "r^-1" ]

    swap =
      button [ onClick Swap ] [ text "s" ]

    permutation =
      viewPermutation model.permutation
  in
    div []
        ([ rotate, inverse, swap ] ++ permutation)


viewPermutation : List a -> List (Html Message)
viewPermutation permutation =
  List.map viewElement permutation

viewElement : a -> Html Message
viewElement n =
  span [] [ text (toString n) ]
