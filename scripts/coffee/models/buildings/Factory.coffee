define [
      "models/buildings/Workable"
      "Backbone"
    ], (
      WorkableModel) ->

  Factory = WorkableModel.extend
    defaults:
      needsWorker: true
      cost: 60
      value: 5
