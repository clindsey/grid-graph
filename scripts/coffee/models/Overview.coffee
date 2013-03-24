define [
      "collections/Buildings"
      "Backbone"
    ], (
      buildings) ->

  Overview = Backbone.Model.extend
    defaults:
      wood: 250
      food: 100
      metal: 0

    initialize: ->
      @listenTo buildings, "madeResources", @onMadeResources

    onMadeResources: (resources) ->
      woodCount = @get "wood"
      woodCount += resources.wood
      @set "wood", woodCount

      foodCount = @get "food"
      foodCount += resources.food
      @set "food", foodCount

      metalCount = @get "metal"
      metalCount += resources.metal
      @set "metal", metalCount

    removeResources: (resources) ->
      woodCount = @get "wood"
      woodCount -= resources.wood
      @set "wood", woodCount

      foodCount = @get "food"
      foodCount -= resources.food
      @set "food", foodCount

      metalCount = @get "metal"
      metalCount -= resources.metal
      @set "metal", metalCount

    purchase: (resources) ->
      if @get("wood") < resources.wood
        return false

      if @get("food") < resources.food
        return false

      if @get("metal") < resources.metal
        return false

      @removeResources resources

      true

  new Overview
