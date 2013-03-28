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

      @

    onListItemClick: (jqEvent) ->
      jqEvent.preventDefault()

      @model.activate()
