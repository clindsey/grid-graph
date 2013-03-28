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
      @$("ul").html @template {}

      planets.each (planet) =>
        planetListItemView = new PlanetListItemView
          model: planet

        @$el.append planetListItemView.render().$el

      @
