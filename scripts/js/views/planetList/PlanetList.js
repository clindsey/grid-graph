(function() {

  define(["text!../../../../templates/planetList/planetList.html", "collections/Planets", "views/planetList/PlanetListItem", "Backbone"], function(planetListTemplate, planets, PlanetListItemView) {
    var PlanetListView;
    return PlanetListView = Backbone.View.extend({
      el: ".planet-list",
      template: _.template(planetListTemplate),
      initialize: function() {
        return this.listenTo(planets, "reset", this.render);
      },
      render: function() {
        var _this = this;
        this.$el.html(this.template({}));
        planets.each(function(planet) {
          var planetListItemView;
          planetListItemView = new PlanetListItemView({
            model: planet
          });
          return _this.$("ul").append(planetListItemView.render().$el);
        });
        return this;
      }
    });
  });

}).call(this);
