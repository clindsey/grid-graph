define [
      "text!../../../../templates/toolbar/toolbar.html"
      "models/Overview"
      "Backbone"
      "Bootstrap"
    ], (
      toolbarTemplate,
      overviewModel) ->

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
      @listenTo overviewModel, "change:money", @onMoneyChanged

      @render()

      @onMoneyChanged()

    render: ->
      @$el.html @template @contextIconLookup[@menuOption]

      @$(".btn-group > .#{@activeContext}-btn").addClass "active btn-primary"

      @$("[data-toggle=tooltip]").tooltip
        container: "body"
        placement: "left"
        html: true

      @

    onDropdownItemClick: (jqEvent) ->
      jqEvent.preventDefault()
      jqEvent.stopPropagation()

      @$("[data-toggle=tooltip]").tooltip "hide"

      @render()

      @$(".dropdown-toggle, .btn-group.open").removeClass "active open"
      @$(".dropdown-btn").addClass "active btn-primary"

    onBtnClick: (jqEvent) ->
      if $(jqEvent.currentTarget).hasClass "dropdown-toggle"
        return

      @$(".btn").removeClass "active btn-primary"

      $(jqEvent.currentTarget).addClass "active btn-primary"

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
      money = overviewModel.get "money"

      @$(".money-count").html "$#{money}"
