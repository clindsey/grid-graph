define [
      "Backbone"
    ], (
      ) ->

  ToolbarView = Backbone.View.extend
    el: ".action-toolbar"

    activeContext: "move"

    events:
      "click .btn": "onBtnClick"
      "click .move-btn": "onMoveBtnClick"
      "click .road-btn": "onRoadBtnClick"
      "click .home-btn": "onHomeBtnClick"
      "click .farm-btn": "onFarmBtnClick"
      "click .refinery-btn": "onRefineryBtnClick"
      "click .remove-btn": "onRemoveBtnClick"

    initialize: ->
      $(".#{@activeContext}-btn").addClass "active"

    onBtnClick: (jqEvent) ->
      @$(".btn.active").removeClass "active"

      $(jqEvent.currentTarget).addClass "active"

    onMoveBtnClick: ->
      @activeContext = "move"

    onRoadBtnClick: ->
      @activeContext = "road"

    onHomeBtnClick: ->
      @activeContext = "home"

    onFarmBtnClick: ->
      @activeContext = "farm"

    onRefineryBtnClick: ->
      @activeContext = "refinery"

    onRemoveBtnClick: ->
      @activeContext = "remove"
