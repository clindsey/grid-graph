(function() {

  define(["views/viewport/Viewport", "models/Viewport", "views/toolbar/Toolbar", "models/heightmap/Heightmap", "Alea", "Backbone"], function(ViewportView, viewportModel, ToolbarView, heightmapModel) {
    var AppView;
    return AppView = Backbone.View.extend({
      el: document,
      initialize: function() {
        var toolbarView;
        toolbarView = new ToolbarView;
        new ViewportView({
          toolbarView: toolbarView
        });
        return console.log("seed", heightmapModel.get("SEED"));
      }
    });
  });

}).call(this);
