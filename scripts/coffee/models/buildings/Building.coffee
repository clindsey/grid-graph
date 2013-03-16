define [
      "Backbone"
    ], (
      ) ->

  Building = Backbone.Model.extend
    defaults:
      needsWorker: false
