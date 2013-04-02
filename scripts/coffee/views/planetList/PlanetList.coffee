define [
      "text!../../../../templates/planetList/planetList.html"
      "collections/Planets"
      "views/planetList/PlanetListItem"
      "Backbone"
    ], (
      planetListTemplate
      planets,
      PlanetListItemView) ->

  PlanetListView = Backbone.View.extend
    el: ".map-viewport"

    template: _.template planetListTemplate

    views: []
    activePlanet: undefined

    initialize: ->
      #@listenTo planets, "reset", @render
      @listenTo planets, "active", (activePlanet) =>
        @activePlanet = activePlanet
        @render

    render: ->
      @$el.html @template {}

      _.each @views, (view) -> view.remove()

      @views = []

      planets.each (planet) =>
        isActive = planet.get("seed") is @activePlanet.get("seed")

        planetListItemView = new PlanetListItemView
          model: planet
          isActive: isActive

        @views.push planetListItemView

        @$("ul").append planetListItemView.render().$el

      @
