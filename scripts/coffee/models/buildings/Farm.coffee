define [
      "models/buildings/Building"
      "Backbone"
    ], (
      BuildingModel) ->

  Farm = BuildingModel.extend
    defaults:
      needsWorker: true
