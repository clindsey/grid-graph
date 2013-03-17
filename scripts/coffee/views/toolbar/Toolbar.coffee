define [
      "text!../../../../templates/toolbar/toolbar.html"
      "models/Foreman"
      "Backbone"
      "Bootstrap"
    ], (
      toolbarTemplate,
      foremanModel) ->

  ToolbarView = Backbone.View.extend
    el: ".action-toolbar"

    activeContext: "move"

    menuOption: "road"

    template: _.template toolbarTemplate

    events:
      "click .btn": "onBtnClick"
      "click .dropdown-btn": "onDropdownBtnClick"
      "click .dropdown-menu .road-btn": "onRoadBtnClick"
      "click .dropdown-menu .home-btn": "onHomeBtnClick"
      "click .dropdown-menu .farm-btn": "onFarmBtnClick"
      "click .dropdown-menu .mine-btn": "onMineBtnClick"
      "click .dropdown-menu .lumber-mill-btn": "onLumberMillBtnClick"
      "click .dropdown-menu .water-well-btn": "onWaterWellBtnClick"
      "click .dropdown-menu .factory-btn": "onFactoryBtnClick"
      "click .move-btn": "onMoveBtnClick"
      "click .remove-btn": "onRemoveBtnClick"
      "click .dropdown-menu a": "onDropdownItemClick"

    contextIconLookup:
      "road":
        icon: "road"
        label: "Road"
      "home":
        icon: "home"
        label: "House"
      "farm":
        icon: "leaf"
        label: "Farm"
      "mine":
        icon: "filter"
        label: "Mine"
      "lumber mill":
        icon: "inbox"
        label: "Lumber Mill"
      "water well":
        icon: "tint"
        label: "Water Well"
      "factory":
        icon: "cogs"
        label: "Factory"

    initialize: ->
      @listenTo foremanModel, "change:money", @onMoneyChanged

      @onMoneyChanged()

      @render()

    render: ->
      @$el.html @template @contextIconLookup[@menuOption]

      $(".#{@activeContext}-btn").addClass "active"

      @

    onDropdownItemClick: (jqEvent) ->
      jqEvent.preventDefault()
      jqEvent.stopPropagation()

      @render()

      @$(".dropdown-toggle, .btn-group.open").removeClass "active open"
      @$(".dropdown-btn").addClass "active"

    onBtnClick: (jqEvent) ->
      @$(".btn").removeClass "active"

      $(jqEvent.currentTarget).addClass "active"

    onMoveBtnClick: ->
      @activeContext = "move"

    onDropdownBtnClick: ->
      @activeContext = @menuOption

    onRoadBtnClick: ->
      @activeContext = "road"
      @menuOption = "road"

    onHomeBtnClick: ->
      @activeContext = "home"
      @menuOption = "home"

    onFarmBtnClick: ->
      @activeContext = "farm"
      @menuOption = "farm"

    onMineBtnClick: ->
      @activeContext = "mine"
      @menuOption = "mine"

    onLumberMillBtnClick: ->
      @activeContext = "lumber mill"
      @menuOption = "lumber mill"

    onWaterWellBtnClick: ->
      @activeContext = "water well"
      @menuOption = "water well"

    onFactoryBtnClick: ->
      @activeContext = "factory"
      @menuOption = "factory"

    onRemoveBtnClick: ->
      @activeContext = "remove"

    onMoneyChanged: ->
      money = foremanModel.get "money"

      $(".money-count").html "$#{money}"
