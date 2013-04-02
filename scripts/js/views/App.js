(function() {

  define(["views/viewport/Viewport", "models/Viewport", "views/toolbar/Toolbar", "models/heightmap/Heightmap", "models/Galaxy", "views/planetList/PlanetList", "collections/Planets", "collections/Buildings", "collections/Creatures", "Alea", "Backbone"], function(ViewportView, viewportModel, ToolbarView, heightmapModel, GalaxyModel, PlanetListView, planets, buildings, creatures) {
    var AppView;
    return AppView = Backbone.View.extend({
      el: document,
      initialize: function() {
        var galaxy, isPlanetListOpen, planetListView, toolbarView, viewport;
        isPlanetListOpen = false;
        toolbarView = new ToolbarView;
        galaxy = new GalaxyModel({
          seed: 20130401,
          size: 5
        });
        viewport = new ViewportView({
          toolbarView: toolbarView
        });
        planetListView = new PlanetListView;
        this.listenTo(buildings, "reset", function() {
          viewport.render();
          return creatures.fetch();
        });
        this.listenTo(creatures, "reset", function() {});
        this.listenTo(planets, "active", function(activePlanet) {
          isPlanetListOpen = false;
          return buildings.fetch();
        });
        galaxy.generate();
        planets.first().activate();
        return this.listenTo(toolbarView, "toggleSpaceMap", function() {
          if (!isPlanetListOpen) {
            planetListView.render();
          }
          return isPlanetListOpen = true;
        });
      }
    });
  });

}).call(this);
