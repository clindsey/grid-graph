define [
      "models/buildings/Workable"
      "Backbone"
    ], (
      WorkableModel) ->

  LumberMill = WorkableModel.extend
    defaults:
      needsWorker: true
      cost: 60
      value: 5
