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
        if (this.options.isActive) {
          this.$el.addClass("active");
        }
        return this;
      },
      onListItemClick: function(jqEvent) {
        jqEvent.preventDefault();
        $(".planet-list li.active").removeClass("active");
        return this.model.activate();
      }
    });
  });

}).call(this);
