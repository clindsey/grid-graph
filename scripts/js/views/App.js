(function() {

  define(["views/viewport/Viewport", "models/Viewport", "views/toolbar/Toolbar", "models/heightmap/Heightmap", "models/Galaxy", "views/planetList/PlanetList", "collections/Planets", "Alea", "Backbone"], function(ViewportView, viewportModel, ToolbarView, heightmapModel, GalaxyModel, PlanetListView, planets) {
    var AppView;
    return AppView = Backbone.View.extend({
      el: document,
      initialize: function() {
        var galaxy, toolbarView;
        toolbarView = new ToolbarView;
        galaxy = new GalaxyModel({
          seed: 20130910,
          size: 20
        });
        new PlanetListView;
        galaxy.generate();
        return new ViewportView({
          toolbarView: toolbarView
        });
      }
    });
  });

}).call(this);
