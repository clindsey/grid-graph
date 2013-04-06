define [
      "text!../../../../templates/planetList/planetListItem.html"
      "Backbone"
    ], (
      planetListItemTemplate) ->

  PlanetListItemView = Backbone.View.extend
    tagName: "li"

    template: _.template planetListItemTemplate

    events:
      "click a": "onListItemClick"

    render: ->
      @$el.html @template @model.toJSON()

      if @options.isActive
        @$el.addClass "active"

      @

    onListItemClick: (jqEvent) ->
      jqEvent.preventDefault()

      $(".planet-list li.active").removeClass "active"

      @model.activate()
