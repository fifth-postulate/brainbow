import Html exposing (..)
import Html.App exposing (program)
import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Color exposing (hsl)
import Color.Convert exposing (colorToCssRgb)
import Keyboard exposing (KeyCode)


main =
  program {
    init = init 6
  , view = view
  , update = update
  , subscriptions = subscriptions
  }


-- MODEL


type alias Model =
  {
    permutation: List Int
    , size: Int
  }


init : Int -> (Model, Cmd Message)
init n =
  (initModel n, Cmd.none)


initModel: Int -> Model
initModel n =
  {
    permutation = range n
    , size = n
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
  DoNothing
  | Rotate
  | InverseRotate
  | Swap
  | Increase
  | Decrease


update : Message -> Model -> (Model, Cmd Message)
update msg model =
  case msg of
    DoNothing ->
      (model, Cmd.none)

    Rotate ->
      (
       { model | permutation = rotate model.permutation }
      , Cmd.none
      )

    InverseRotate ->
      (
       { model | permutation = inverseRotate model.permutation }
      , Cmd.none
      )

    Swap ->
      (
       { model | permutation = swapFirst model.permutation }
      , Cmd.none
      )

    Increase ->
      let
        newSize = model.size + 1
      in
        (
         { model | size = newSize, permutation = range newSize }
        , Cmd.none
        )

    Decrease ->
      let
        newSize = Basics.max 2 (model.size - 1)
      in
        (
         { model | size = newSize, permutation = range newSize }
        , Cmd.none
        )


-- VIEW


view : Model -> Html Message
view model =
  let
    decrease =
      button [ onClick Decrease ] [ Html.text "-" ]

    increase =
      button [ onClick Increase ] [ Html.text "+" ]

    rotate =
      button [ onClick Rotate ] [ Html.text "r" ]

    inverse =
      button [ onClick InverseRotate ] [ Html.text "t" ]

    swap =
      button [ onClick Swap ] [ Html.text "s" ]

    brainbow =
      viewPermutationAsSvg model.permutation
  in
    div [] [
      div [] [ decrease, increase ]
      , div [] [ rotate, inverse, swap ]
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
    baseAngle = 2 * pi / (toFloat total)

    angle = (toFloat index) * baseAngle
  in
    colorToCssRgb (hsl angle 1.0 0.5)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Message
subscriptions model =
  Sub.batch [
    Keyboard.downs handlePress
  ]


handlePress : KeyCode -> Message
handlePress keycode =
  case keycode of
    82 -> Rotate

    83 -> Swap

    84 -> InverseRotate

    _ -> DoNothing
