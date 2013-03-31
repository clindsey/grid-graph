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
    el: ".planet-list"

    template: _.template planetListTemplate

    initialize: ->
      @listenTo planets, "reset", @render

    render: ->
      @$el.html @template {}

      planets.each (planet) =>
        planetListItemView = new PlanetListItemView
          model: planet

        @$("ul").append planetListItemView.render().$el

      @
