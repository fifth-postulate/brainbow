# brainbow
An Elm project implementing the brainbow puzzle.

Play it [now][puzzle].

## Getting Started
Follow the next instructions to start puzzling.

1. [Install elm][install].
2. Clone this repo and `cd` into it.
3. Run `elm reactor`.
4. Open [https://localhost:8000/src/Brainbow.elm][local]

## Install with [bower][]
You can install the JavaScript file from bower with the following command.

```sh
bower install brainbow
```

This will install the file `brainbow/js/brainbow.js` inside of the
bower_components directory. To use it create a HTML file reference the
`brainbow.js` file and embed the brainbow.

```html
<div id="container"></div>
<script src="js/brainbow.js"></script>
<script>
  var node = document.getElementById('container');
  var app = Elm.Brainbow.embed(node);
</script>
```

[install]: http://elm-lang.org/install
[local]: http://localhost:8000/src/Brainbow.elm
[puzzle]: http://fifth-postulate.nl/brainbow
[bower]: https://bower.io/
