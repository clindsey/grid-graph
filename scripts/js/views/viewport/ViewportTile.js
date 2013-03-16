// Generated by CoffeeScript 1.4.0
(function() {

  define(["models/heightmap/Heightmap", "Backbone"], function(heightmapModel) {
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
        var buildingView, type;
        buildingView = this.model.get("buildingView");
        if (buildingView != null) {
          this.backgroundPositionX = buildingView.backgroundPositionX;
          return this.backgroundPositionY = buildingView.backgroundPositionY;
        } else {
          type = this.model.get("type");
          this.backgroundPositionX = 0 - ((type % 16) * 16);
          return this.backgroundPositionY = 0 - (~~(type / 16) * 16);
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
