(function() {

  define(["views/viewport/Viewport", "models/Viewport", "views/toolbar/Toolbar", "models/heightmap/Heightmap", "models/Galaxy", "views/planetList/PlanetList", "collections/Planets", "collections/Buildings", "Alea", "Backbone"], function(ViewportView, viewportModel, ToolbarView, heightmapModel, GalaxyModel, PlanetListView, planets, buildings) {
    var AppView;
    return AppView = Backbone.View.extend({
      el: document,
      initialize: function() {
        var galaxy, toolbarView;
        toolbarView = new ToolbarView;
        galaxy = new GalaxyModel({
          seed: 20130910,
          size: 1
        });
        new PlanetListView;
        galaxy.generate();
        new ViewportView({
          toolbarView: toolbarView
        });
        return buildings.fetch();
      }
    });
  });

}).call(this);
