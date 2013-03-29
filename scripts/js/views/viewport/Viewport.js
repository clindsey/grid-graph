(function() {

  define(["collections/ViewportTiles", "views/viewport/ViewportTile", "models/Viewport", "models/heightmap/Heightmap", "collections/Creatures", "collections/Buildings", "models/entities/Creature", "views/entities/Creature", "models/Foreman", "models/buildings/Home", "views/buildings/Home", "models/buildings/Farm", "views/buildings/Farm", "models/buildings/Road", "views/buildings/Road", "models/buildings/Mine", "views/buildings/Mine", "models/buildings/LumberMill", "views/buildings/LumberMill", "models/buildings/WaterWell", "views/buildings/WaterWell", "models/buildings/Factory", "views/buildings/Factory", "collections/MapTiles", "Backbone"], function(viewportTiles, ViewportTileView, viewportModel, heightmapModel, creatures, buildings, CreatureModel, CreatureView, foremanModel, HomeModel, HomeView, FarmModel, FarmView, RoadModel, RoadView, MineModel, MineView, LumberMillModel, LumberMillView, WaterWellModel, WaterWellView, FactoryModel, FactoryView, mapTiles) {
    var ViewportView;
    return ViewportView = Backbone.View.extend({
      el: ".map-viewport",
      events: {
        "click": "onClick"
      },
      initialize: function() {
        _.bindAll(this, "onMapTileClick");
        this.render();
        this.listenTo(viewportModel, "moved", this.onViewportMoved);
        this.listenTo(creatures, "add", this.onCreatureAdded);
        this.listenTo(buildings, "add", this.onBuildingAdded);
        this.listenTo(buildings, "remove", this.onBuildingRemoved);
        return this.listenTo(buildings, "reset", this.onBuildingsReset);
      },
      render: function() {
        var interval,
          _this = this;
        this.$el.css({
          width: viewportModel.get("width") * 16,
          height: viewportModel.get("height") * 16
        });
        this.grid = [];
        viewportTiles.each(function(mapTileModel) {
          var viewportTileView;
          viewportTileView = new ViewportTileView;
          viewportTileView.setModel(mapTileModel);
          _this.$el.append(viewportTileView.render().$el);
          viewportTileView.$el.click(function() {
            return _this.onMapTileClick(viewportTileView);
          });
          return _this.grid.push(viewportTileView);
        });
        interval = function(time, cb) {
          return setInterval(cb, time);
        };
        interval(1000 / 1, function() {
          try {
            return creatures.invoke("trigger", "tick");
          } catch (err) {
            return console.log("machine.js state tick err:", err);
          }
        });
        return this;
      },
      onClick: function(jqEvent) {
        if (this.options.toolbarView.activeContext === "move") {
          return this.moveViewport(jqEvent);
        }
      },
      onMapTileClick: function(viewportTileView) {
        var context, tileModel;
        tileModel = viewportTileView.model;
        context = this.options.toolbarView.activeContext;
        if (tileModel.get("isOccupied") === true && context !== "remove") {
          return;
        }
        if (tileModel.get("type") !== 255) {
          return;
        }
        switch (this.options.toolbarView.activeContext) {
          case "move":
            return "";
          case "road":
            return foremanModel.putRoad(tileModel);
          case "home":
            return foremanModel.putHome(tileModel);
          case "farm":
            return foremanModel.putFarm(tileModel);
          case "mine":
            return foremanModel.putMine(tileModel);
          case "lumber mill":
            return foremanModel.putLumberMill(tileModel);
          case "water well":
            return foremanModel.putWaterWell(tileModel);
          case "factory":
            return foremanModel.putFactory(tileModel);
          case "remove":
            if (tileModel.get("isOccupied")) {
              return foremanModel.removeBuilding(tileModel);
            }
        }
      },
      moveViewport: function(jqEvent) {
        var tileX, tileY, viewportHeight, viewportWidth, viewportX, viewportY, vx, vy;
        viewportWidth = viewportModel.get("width");
        viewportHeight = viewportModel.get("height");
        tileX = ~~(jqEvent.target.offsetLeft / 16);
        tileY = ~~(jqEvent.target.offsetTop / 16);
        vx = tileX - ~~(viewportWidth / 2);
        vy = tileY - ~~(viewportHeight / 2);
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
      onCreatureAdded: function(creatureModel) {
        var creatureView;
        creatureView = new CreatureView({
          model: creatureModel
        });
        return this.$el.append(creatureView.render().$el);
      },
      onBuildingRemoved: function(buildingModel) {
        var creatureModel, tileModel, tileModels, workSite;
        tileModels = mapTiles.where({
          x: buildingModel.get("x"),
          y: buildingModel.get("y")
        });
        tileModel = _.first(tileModels);
        tileModel.set("buildingView", void 0);
        creatureModel = buildingModel.get("creature");
        if (creatureModel != null) {
          creatures.remove(creatureModel);
          workSite = creatureModel.get("workSite");
          if (workSite != null) {
            workSite.set("worker", void 0);
          }
        }
        creatureModel = buildingModel.get("worker");
        if (creatureModel != null) {
          return creatureModel.set("workSite", void 0);
        }
      },
      onBuildingsReset: function() {
        var _this = this;
        return buildings.each(function(building) {
          return _this.onBuildingAdded(building);
        });
      },
      onBuildingAdded: function(buildingModel) {
        var buildingView, tileModel, tileModels;
        switch (buildingModel.get("type")) {
          case "Home":
            buildingView = new HomeView({
              model: buildingModel
            });
            break;
          case "Farm":
            buildingView = new FarmView({
              model: buildingModel
            });
            break;
          case "Road":
            buildingView = new RoadView({
              model: buildingModel
            });
            break;
          case "Mine":
            buildingView = new MineView({
              model: buildingModel
            });
            break;
          case "LumberMill":
            buildingView = new LumberMillView({
              model: buildingModel
            });
            break;
          case "WaterWell":
            buildingView = new WaterWellView({
              model: buildingModel
            });
            break;
          case "Factory":
            buildingView = new FactoryView({
              model: buildingModel
            });
            break;
          default:
            return;
        }
        tileModels = mapTiles.where({
          x: buildingModel.get("x"),
          y: buildingModel.get("y")
        });
        tileModel = _.first(tileModels);
        return tileModel.set("buildingView", buildingView);
      }
    });
  });

}).call(this);
