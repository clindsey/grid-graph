define [
      "Backbone"
    ], (
      ) ->

  MapTile = Backbone.Model.extend
    defaults:
      type: 0
      isOccupied: false
      buildingView: undefined

    initialize: ->
      @listenTo @, "change:buildingView", @setOccupied

    setOccupied: ->
      buildingType = @get "buildingView"

      if buildingType?
        @set "isOccupied", true
      else
        @set "isOccupied", false
