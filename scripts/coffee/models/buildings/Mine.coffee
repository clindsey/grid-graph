define [
      "models/buildings/Workable"
      "Backbone"
    ], (
      WorkableModel) ->

  Mine = WorkableModel.extend
    defaults:
      type: "Mine"
      needsWorker: true
      resources:
        wood: 20
        food: 10
        metal: 0
      production:
        wood: 0
        food: 0
        metal: 5
