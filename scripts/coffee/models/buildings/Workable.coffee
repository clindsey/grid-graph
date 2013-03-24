define [
      "models/buildings/Building"
      "Backbone"
    ], (
      BuildingModel) ->

  Workable = BuildingModel.extend
    defaults:
      needsWorker: true
      production:
        wood: 0
        food: 0
        metal: 0
      resources:
        wood: 0
        food: 0
        metal: 0

    initialize: ->
      BuildingModel.prototype.initialize.call @

      @listenTo @, "worked", @onWorked

    onWorked: ->
      @trigger "madeResources", @get "production"
