define [
      "models/NameMaker"
      "Backbone"
    ], (
      nameMaker) ->

  Planet = Backbone.Model.extend
    defaults:
      seed: 1364432313865
      name: "Unnamed"

    initialize: ->
      @set "name", nameMaker.getName @get "seed"

    activate: ->
      @trigger "active", @
