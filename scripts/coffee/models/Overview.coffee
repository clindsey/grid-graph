define [
      "collections/Buildings"
      "Backbone"
    ], (
      buildings) ->

  Overview = Backbone.Model.extend
    defaults:
      money: 500

    initialize: ->
      @listenTo buildings, "madeMoney", @onMadeMoney

    onMadeMoney: (amount) ->
      money = @get "money"

      money += amount

      @set "money", money

    removeMoney: (amount) ->
      money = @get "money"

      money -= amount

      @set "money", money

    purchase: (amount) ->
      if @get("money") < amount
        return false

      @removeMoney amount

      true

  new Overview
