(function() {

  define(["text!../../../../templates/planetList/planetListItem.html", "Backbone"], function(planetListItemTemplate) {
    var PlanetListItemView;
    return PlanetListItemView = Backbone.View.extend({
      tagName: "li",
      template: _.template(planetListItemTemplate),
      events: {
        "click a": "onListItemClick"
      },
      initialize: function() {
        return this.listenTo(this.model, "active", this.onActive);
      },
      render: function() {
        this.$el.html(this.template(this.model.toJSON()));
        return this;
      },
      onActive: function() {
        return this.$el.addClass("active");
      },
      onListItemClick: function(jqEvent) {
        jqEvent.preventDefault();
        $(".planet-list li.active").removeClass("active");
        return this.model.activate();
      }
    });
  });

}).call(this);
