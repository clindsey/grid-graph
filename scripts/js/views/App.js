(function() {

  define(["views/viewport/Viewport", "models/Viewport", "views/toolbar/Toolbar", "models/heightmap/Heightmap", "models/Galaxy", "views/planetList/PlanetList", "collections/Planets", "collections/Buildings", "collections/Creatures", "Alea", "Backbone"], function(ViewportView, viewportModel, ToolbarView, heightmapModel, GalaxyModel, PlanetListView, planets, buildings, creatures) {
    var AppView;
    return AppView = Backbone.View.extend({
      el: document,
      initialize: function() {
        var galaxy, toolbarView;
        toolbarView = new ToolbarView;
        galaxy = new GalaxyModel({
          seed: 20130330,
          size: 1
        });
        new PlanetListView;
        galaxy.generate();
        new ViewportView({
          toolbarView: toolbarView
        });
        this.listenTo(buildings, "reset", function() {
          return creatures.fetch();
        });
        return buildings.fetch();
      }
    });
  });

}).call(this);
