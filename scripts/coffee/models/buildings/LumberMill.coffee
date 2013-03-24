define [
      "models/buildings/Workable"
      "Backbone"
    ], (
      WorkableModel) ->

  LumberMill = WorkableModel.extend
    defaults:
      needsWorker: true
      resources:
        wood: 0
        food: 10
        metal: 20
      production:
        wood: 10
        food: 0
        metal: 0
