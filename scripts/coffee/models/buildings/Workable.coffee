define [
      "models/buildings/Building"
      "Backbone"
    ], (
      BuildingModel) ->

  Workable = BuildingModel.extend
    defaults:
      needsWorker: true
      cost: 0
      value: 0

    initialize: ->
      BuildingModel.prototype.initialize.call @

      @listenTo @, "worked", @onWorked

    onWorked: ->
      @trigger "madeMoney", @get "value"
