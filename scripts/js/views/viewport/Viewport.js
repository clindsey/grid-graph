// Generated by CoffeeScript 1.4.0
(function() {

  define(["collections/ViewportTiles", "views/viewport/ViewportTile", "models/Viewport", "models/Heightmap", "Alea", "Backbone"], function(viewportTiles, ViewportTileView, viewportModel, heightmapModel) {
    var ViewportView;
    return ViewportView = Backbone.View.extend({
      el: ".map-viewport",
      events: {
        "click": "onClick"
      },
      initialize: function() {
        _.bindAll(this, "onMapTileClick");
        this.rnd = new Alea(heightmapModel.get("SEED"));
        this.render();
        return this.listenTo(viewportModel, "moved", this.onViewportMoved);
      },
      render: function() {
        var _this = this;
        this.$el.css({
          width: viewportModel.get("width") * 16,
          height: viewportModel.get("height") * 16
        });
        this.grid = [];
        viewportTiles.each(function(viewportTileModel) {
          var viewportTileView;
          viewportTileView = new ViewportTileView;
          viewportTileView.setModel(viewportTileModel);
          _this.$el.append(viewportTileView.render().$el);
          viewportTileView.$el.click(function() {
            return _this.onMapTileClick(viewportTileView);
          });
          return _this.grid.push(viewportTileView);
        });
        return this;
      },
      onClick: function(jqEvent) {
        if (this.options.toolbarView.activeContext === "move") {
          return this.moveViewport(jqEvent);
        }
      },
      onMapTileClick: function(viewportTileView) {
        var tileModel;
        tileModel = viewportTileView.model;
        switch (this.options.toolbarView.activeContext) {
          case "move":
            return "";
          case "road":
            return this.putRoad(tileModel);
          case "home":
            return this.putHome(tileModel);
          case "farm":
            return this.putFarm(tileModel);
          case "refinery":
            return this.putRefinery(tileModel);
          case "remove":
            if (tileModel.get("isOccupied")) {
              tileModel.removeOccupant();
              return this.informNeighbors(tileModel);
            }
        }
      },
      moveViewport: function(jqEvent) {
        var tileX, tileY, viewportHeight, viewportWidth, viewportX, viewportY, vx, vy;
        viewportWidth = viewportModel.get("width");
        viewportHeight = viewportModel.get("height");
        tileX = ~~(jqEvent.target.offsetLeft / 16);
        tileY = ~~(jqEvent.target.offsetTop / 16);
        vx = tileX - Math.floor(viewportWidth / 2);
        vy = tileY - Math.floor(viewportHeight / 2);
        viewportX = viewportModel.get("x");
        viewportY = viewportModel.get("y");
        return viewportModel.set({
          x: viewportX + vx,
          y: viewportY + vy
        });
      },
      onViewportMoved: function() {
        return _.each(this.grid, function(viewportTileView, index) {
          return viewportTileView.setModel(viewportTiles.at(index));
        });
      },
      putHome: function(tileModel) {
        tileModel.set("buildingType", 1);
        return this.informNeighbors(tileModel);
      },
      putFarm: function(tileModel) {
        tileModel.set("buildingType", 3);
        return this.informNeighbors(tileModel);
      },
      putRefinery: function(tileModel) {
        tileModel.set("buildingType", 2);
        return this.informNeighbors(tileModel);
      },
      putRoad: function(tileModel) {
        var occupied, roadType, tileType;
        roadType = tileModel.get("roadType");
        occupied = tileModel.get("isOccupied");
        tileType = tileModel.get("type");
        if (occupied === false && tileType === 255) {
          tileModel.set("roadType", 1);
          return this.informNeighbors(tileModel);
        }
      },
      informNeighbors: function(tileModel) {
        var heightmapData, x, y;
        x = tileModel.get("x");
        y = tileModel.get("y");
        heightmapData = heightmapModel.get("data");
        heightmapData[this.clampY(y - 1)][x].trigger("neighborChanged");
        heightmapData[y][this.clampX(x + 1)].trigger("neighborChanged");
        heightmapData[this.clampY(y + 1)][x].trigger("neighborChanged");
        return heightmapData[y][this.clampX(x - 1)].trigger("neighborChanged");
      },
      clampX: function(x) {
        var width;
        width = heightmapModel.get("worldTileWidth");
        return (x + width) % width;
      },
      clampY: function(y) {
        var height;
        height = heightmapModel.get("worldTileHeight");
        return (y + height) % height;
      }
    });
  });

}).call(this);
