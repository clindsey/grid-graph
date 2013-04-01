define [
      "models/buildings/Workable"
      "Backbone"
    ], (
      WorkableModel) ->

  ExportCenter = WorkableModel.extend
    defaults:
      type: "ExportCenter"
      needsWorker: false
