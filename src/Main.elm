import Html exposing (..)
import Html.App exposing (beginnerProgram)
import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Color exposing (hsl)
import Color.Convert exposing (colorToCssRgb)


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
      button [ onClick Rotate ] [ Html.text "r" ]

    inverse =
      button [ onClick InverseRotate ] [ Html.text "r^-1" ]

    swap =
      button [ onClick Swap ] [ Html.text "s" ]

    brainbow =
      viewPermutationAsSvg model.permutation
  in
    div [] [
      rotate
      , inverse
      , swap
      , brainbow
    ]


viewPermutationAsSvg : List Int -> Html Message
viewPermutationAsSvg permutation =
  let
    size = (List.length permutation) - 1
  in
    Svg.svg [ width "480", height "480", viewBox "-240 -240 480 480"] [
      g [ fill "none", stroke "black" ] (bow 240 permutation)
      , g [] (bow 80 [0..(size)])
    ]


bow : Int -> List Int -> List (Svg Message)
bow radius permutation =
  let
    total = List.length permutation

    mapper = \position -> (\index -> (segment position index total radius))
  in
    List.indexedMap mapper permutation


segment : Int -> Int -> Int -> Int -> Svg Message
segment position index total radius =
  let
    color = (segmentColor index total)

    baseAngle = 2 * pi / (toFloat total)

    alpha = (toFloat position) * baseAngle

    beta = (toFloat position + 1) * baseAngle

    r = (toFloat radius)

    x0 = r * (cos alpha)

    y0 = r * (sin alpha)

    x1 = r * (cos beta)

    y1 = r * (sin beta)
  in
    g [ stroke "black", fill color ] [
      Svg.path [ d ("M 0 0 "
                   ++ "L" ++ (toString x0) ++ " " ++ (toString y0)
                   ++ "A" ++ (toString r)  ++ " " ++ (toString r) ++ " 0 0 1 " ++ (toString x1) ++ " " ++ (toString y1)
                   ++ "Z") ] []
    ]


segmentColor : Int -> Int -> String
segmentColor index total =
  let
    baseAngle = 360 / (toFloat total)

    angle = (toFloat index) * baseAngle
  in
    colorToCssRgb (hsl angle 1.0 0.5)
