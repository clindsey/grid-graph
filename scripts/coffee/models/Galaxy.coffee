define [
      "models/Planet"
      "collections/Planets"
      "Alea"
      "Backbone"
    ], (
      PlanetModel,
      planets) ->

  Galaxy = Backbone.Model.extend
    defaults:
      seed: 1364432313865
      size: 256

    generate: ->
      random = new Alea(@get "seed")
      planetModels = []

      for index in [1..(@get "size")]
        planet = new PlanetModel
          seed: ~~(random() * 0xffffff)

        planetModels.push planet

      planets.reset planetModels
