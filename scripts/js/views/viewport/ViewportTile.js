// Generated by CoffeeScript 1.4.0
(function() {

  define(["models/Heightmap", "Backbone"], function(heightmap) {
    var ViewportTile;
    return ViewportTile = Backbone.View.extend({
      tagName: "div",
      className: "map-tile",
      events: {
        "click": "onClick"
      },
      render: function() {
        this.calculateBackgroundPosition();
        this.setBackgroundPosition();
        return this;
      },
      setModel: function(model) {
        this.model = model;
        this.setListeners();
        return this.render();
      },
      onClick: function() {
        var roadType, tileType, x, y;
        roadType = this.model.get("roadType");
        tileType = this.model.get("type");
        if (roadType === 1 || tileType === 255) {
          if (roadType === 1) {
            this.model.set("roadType", 0);
          } else {
            this.model.set("roadType", 1);
          }
          x = this.model.get("x");
          y = this.model.get("y");
          heightmap.get("data")[this.clampY(y - 1)][x].trigger("neighborRoadChanged");
          heightmap.get("data")[y][this.clampX(x + 1)].trigger("neighborRoadChanged");
          heightmap.get("data")[this.clampY(y + 1)][x].trigger("neighborRoadChanged");
          return heightmap.get("data")[y][this.clampX(x - 1)].trigger("neighborRoadChanged");
        }
      },
      clampX: function(x) {
        var width;
        width = heightmap.get("worldTileWidth");
        return (x + width) % width;
      },
      clampY: function(y) {
        var height;
        height = heightmap.get("worldTileHeight");
        return (y + height) % height;
      },
      calculateBackgroundPosition: function() {
        var roadTileType, roadType, type;
        type = this.model.get("type");
        roadType = this.model.get("roadType");
        if (roadType === 0) {
          this.backgroundPositionX = 0 - ((type % 16) * 16);
          return this.backgroundPositionY = 0 - (~~(type / 16) * 16);
        } else {
          roadTileType = this.calculateRoadTile();
          this.backgroundPositionX = 0 - roadTileType * 16;
          return this.backgroundPositionY = 0 - 256;
        }
      },
      calculateRoadTile: function() {
        var a, b, c, d, e, n, s, t, w, x, y;
        x = this.model.get("x");
        y = this.model.get("y");
        n = heightmap.get("data")[this.clampY(y - 1)][x].get("roadType");
        e = heightmap.get("data")[y][this.clampX(x + 1)].get("roadType");
        s = heightmap.get("data")[this.clampY(y + 1)][x].get("roadType");
        w = heightmap.get("data")[y][this.clampX(x - 1)].get("roadType");
        a = n << n * 4 - 4;
        b = e << e * 4 - 3;
        c = s << s * 4 - 2;
        d = w << w * 4 - 1;
        return t = a + b + c + d;
      },
      setListeners: function() {
        this.listenTo(this.model, "change:roadType", this.render);
        return this.listenTo(this.model, "neighborRoadChanged", this.render);
      },
      setBackgroundPosition: function() {
        this.$el.css({
          backgroundPosition: "" + this.backgroundPositionX + "px " + this.backgroundPositionY + "px"
        });
        return this;
      }
    });
  });

}).call(this);
