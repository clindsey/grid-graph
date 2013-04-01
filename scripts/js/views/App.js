(function() {

  define(["views/viewport/Viewport", "models/Viewport", "views/toolbar/Toolbar", "models/heightmap/Heightmap", "models/Galaxy", "views/planetList/PlanetList", "collections/Planets", "collections/Buildings", "collections/Creatures", "Alea", "Backbone"], function(ViewportView, viewportModel, ToolbarView, heightmapModel, GalaxyModel, PlanetListView, planets, buildings, creatures) {
    var AppView;
    return AppView = Backbone.View.extend({
      el: document,
      initialize: function() {
        var galaxy, toolbarView, viewport;
        toolbarView = new ToolbarView;
        galaxy = new GalaxyModel({
          seed: 20130401,
          size: 5
        });
        viewport = new ViewportView({
          toolbarView: toolbarView
        });
        new PlanetListView;
        this.listenTo(buildings, "reset", function() {
          viewport.render();
          return creatures.fetch();
        });
        this.listenTo(creatures, "reset", function() {});
        this.listenTo(planets, "active", function(activePlanet) {
          return buildings.fetch();
        });
        galaxy.generate();
        return planets.first().activate();
      }
    });
  });

}).call(this);
