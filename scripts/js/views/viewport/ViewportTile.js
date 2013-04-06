(function() {

  define(["models/heightmap/Heightmap", "Alea", "Backbone"], function(heightmapModel) {
    var ViewportTile;
    return ViewportTile = Backbone.View.extend({
      tagName: "div",
      className: "map-tile",
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
      calculateBackgroundPosition: function() {
        var buildingView, seed, type;
        buildingView = this.model.get("buildingView");
        if (buildingView != null) {
          this.backgroundPositionX = buildingView.backgroundPositionX;
          return this.backgroundPositionY = buildingView.backgroundPositionY;
        } else {
          type = this.model.get("type");
          this.backgroundPositionX = 0 - ((type % 16) * 32);
          this.backgroundPositionY = 0 - (~~(type / 16) * 32);
          if (type === 255) {
            seed = this.model.get("seed");
            if (seed > 0.9125) {
              this.backgroundPositionX = 0;
              this.backgroundPositionY = -512;
            }
            if (seed > 0.9875) {
              return this.backgroundPositionX = -192;
            } else if (seed > 0.975) {
              return this.backgroundPositionX = -160;
            } else if (seed > 0.9625) {
              return this.backgroundPositionX = -128;
            } else if (seed > 0.95) {
              return this.backgroundPositionX = -96;
            } else if (seed > 0.9375) {
              return this.backgroundPositionX = -64;
            } else if (seed > 0.925) {
              return this.backgroundPositionX = -32;
            } else if (seed > 0.9125) {
              return this.backgroundPositionX = -0;
            }
          }
        }
      },
      setListeners: function() {
        this.listenTo(this.model, "change:isOccupied", this.render);
        this.listenTo(this.model, "updateBackgroundPosition", this.render);
        return this.listenTo(this.model, "change:buildingView", this.render);
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
