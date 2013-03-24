define [
      "models/buildings/Workable"
      "Backbone"
    ], (
      WorkableModel) ->

  WorkableModel = WorkableModel.extend
    defaults:
      needsWorker: true
      resources:
        wood: 20
        food: 10
        metal: 20
