(function() {

  define(["text!../../../../templates/planetList/planetList.html", "collections/Planets", "views/planetList/PlanetListItem", "Backbone"], function(planetListTemplate, planets, PlanetListItemView) {
    var PlanetListView;
    return PlanetListView = Backbone.View.extend({
      el: ".map-viewport",
      template: _.template(planetListTemplate),
      views: [],
      activePlanet: void 0,
      initialize: function() {
        var _this = this;
        return this.listenTo(planets, "active", function(activePlanet) {
          _this.activePlanet = activePlanet;
          return _this.render;
        });
      },
      render: function() {
        var _this = this;
        this.$el.html(this.template({}));
        _.each(this.views, function(view) {
          return view.remove();
        });
        this.views = [];
        planets.each(function(planet) {
          var isActive, planetListItemView;
          isActive = planet.get("seed") === _this.activePlanet.get("seed");
          planetListItemView = new PlanetListItemView({
            model: planet,
            isActive: isActive
          });
          _this.views.push(planetListItemView);
          return _this.$("ul").append(planetListItemView.render().$el);
        });
        return this;
      }
    });
  });

}).call(this);
