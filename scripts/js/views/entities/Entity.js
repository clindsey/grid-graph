(function() {

  define(["models/Viewport", "models/heightmap/Heightmap", "Backbone"], function(viewportModel, heightmapModel) {
    var Entity;
    return Entity = Backbone.View.extend({
      tagName: "div",
      className: "entity-tile",
      initialize: function() {
        this.listenTo(viewportModel, "moved", this.onViewportMoved);
        this.listenTo(this.model, "change:x", this.onMove);
        this.listenTo(this.model, "change:y", this.onMove);
        return this.listenTo(this.model, "remove", this.remove);
      },
      render: function() {
        this.setPosition();
        return this;
      },
      onMove: function() {
        return this.setPosition();
      },
      onViewportMoved: function() {
        return this.setPosition();
      },
      setPosition: function() {
        var centerX, centerY, halfWorldHeight, halfWorldWidth, myX, myY, offsetX, offsetY, viewX, viewY, worldHeight, worldWidth, x, y;
        centerX = ~~(viewportModel.get("width") / 2);
        centerY = ~~(viewportModel.get("height") / 2);
        viewX = viewportModel.get("x");
        viewY = viewportModel.get("y");
        myX = this.model.get("x");
        myY = this.model.get("y");
        x = (myX - viewX) + centerX;
        y = (myY - viewY) + centerY;
        worldWidth = heightmapModel.get("worldTileWidth");
        halfWorldWidth = ~~(worldWidth / 2);
        worldHeight = heightmapModel.get("worldTileHeight");
        halfWorldHeight = ~~(worldHeight / 2);
        offsetX = 0;
        offsetY = 0;
        if (myX > viewX + halfWorldWidth) {
          offsetX -= worldWidth;
        }
        if (myX < viewX - halfWorldWidth) {
          offsetX += worldWidth;
        }
        if (myY > viewY + halfWorldHeight) {
          offsetY -= worldHeight;
        }
        if (myY < viewY - halfWorldHeight) {
          offsetY += worldHeight;
        }
        return this.$el.css({
          left: (x + offsetX) * (16 * 2),
          top: (y + offsetY) * (16 * 2)
        });
      }
    });
  });

}).call(this);
