define [
      "models/buildings/Workable"
      "Backbone"
    ], (
      WorkableModel) ->

  Mine = WorkableModel.extend
    defaults:
      needsWorker: true
      cost: 60
      value: 5
