require.config
  paths:
    jQuery: "../../vendor/jquery/jquery.dev.1.9.1"
    underscore: "../../vendor/underscore/underscore.dev.1.4.4"
    text: "../../vendor/text/text.dev.2.0.3"
    Backbone: "../../vendor/backbone/backbone.dev.0.9.10"
    localstorage: "../../vendor/backboneLocalStorage/backbone.localStorage"
    Bootstrap: "../../vendor/bootstrap/2.3.0/js/bootstrap"
    Alea: "../../vendor/alea/alea"
    Base: "../../vendor/base/base"
    Machine: "../../vendor/machine/machine"
    AStar: "../../vendor/astar/astar"

  shim:
    underscore:
      exports: "_"
    jQuery:
      exports: "$"
    Backbone:
      [ "underscore", "jQuery" ]
    Machine:
      [ "Base" ]
    Bootstrap:
      [ "jQuery" ]

  urlArgs: "bust=#{ (new Date()).getTime() }"

require [
    "views/App"
  ], (
    AppView) ->

  appView = new AppView
  appView.render()
