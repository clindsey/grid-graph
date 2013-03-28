(function() {

  define(["text!../../../../templates/planetList/planetListItem.html", "Backbone"], function(planetListItemTemplate) {
    var PlanetListItemView;
    return PlanetListItemView = Backbone.View.extend({
      tagName: "li",
      template: _.template(planetListItemTemplate),
      events: {
        "click a": "onListItemClick"
      },
      render: function() {
        this.$el.html(this.template(this.model.toJSON()));
        return this;
      },
      onListItemClick: function(jqEvent) {
        jqEvent.preventDefault();
        return this.model.activate();
      }
    });
  });

}).call(this);
