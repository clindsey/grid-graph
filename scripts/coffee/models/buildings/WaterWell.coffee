define [
      "models/buildings/Workable"
      "Backbone"
    ], (
      WorkableModel) ->

  WorkableModel = WorkableModel.extend
    defaults:
      needsWorker: true
      cost: 60
      value: 5
