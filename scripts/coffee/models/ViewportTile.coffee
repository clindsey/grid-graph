define [
      "Backbone"
    ], (
      ) ->

  ViewportTile = Backbone.Model.extend
    defaults:
      type: 0
      isOccupied: false
      roadType: 0
      buildingType: 0

    initialize: ->
      @listenTo @, "change:roadType", @setOccupied
      @listenTo @, "change:buildingType", @setOccupied

    setOccupied: ->
      if @roadType is 0 and @buildingType is 0
        @set "isOccupied", false
      else
        @set "isOccupied", true

    removeOccupant: ->
      @set "roadType", 0
      @set "buildingType", 0
      @set "isOccupied", false
