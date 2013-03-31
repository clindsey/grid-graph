(function() {

  define(["collections/ViewportTiles", "views/viewport/ViewportTile", "models/Viewport", "models/heightmap/Heightmap", "collections/Creatures", "collections/Buildings", "models/entities/Creature", "views/entities/Creature", "models/Foreman", "models/buildings/Home", "views/buildings/Home", "models/buildings/Farm", "views/buildings/Farm", "models/buildings/Road", "views/buildings/Road", "models/buildings/Mine", "views/buildings/Mine", "models/buildings/LumberMill", "views/buildings/LumberMill", "models/buildings/WaterWell", "views/buildings/WaterWell", "models/buildings/Factory", "views/buildings/Factory", "collections/MapTiles", "models/Overview", "Backbone"], function(viewportTiles, ViewportTileView, viewportModel, heightmapModel, creatures, buildings, CreatureModel, CreatureView, foremanModel, HomeModel, HomeView, FarmModel, FarmView, RoadModel, RoadView, MineModel, MineView, LumberMillModel, LumberMillView, WaterWellModel, WaterWellView, FactoryModel, FactoryView, mapTiles, overview) {
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
        this.listenTo(buildings, "reset", this.onBuildingsReset);
        return this.listenTo(creatures, "reset", this.onCreaturesReset);
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
        creatureModel = _.first(creatures.where({
          id: buildingModel.get("creatureFk")
        }));
        if (creatureModel != null) {
          creatures.sync("delete", creatureModel);
          creatures.remove(creatureModel);
          workSite = _.first(buildings.where({
            id: creatureModel.get("workSiteFk")
          }));
          if (workSite != null) {
            workSite.set("workerFk", void 0);
            buildings.sync("update", workSite);
          }
        }
        creatureModel = _.first(creatures.where({
          id: buildingModel.get("workerFk")
        }));
        if (creatureModel != null) {
          creatureModel.set("workSiteFk", void 0);
          return creatures.sync("update", creatureModel);
        }
      },
      onCreaturesReset: function() {
        var _this = this;
        return creatures.each(function(creature) {
          _this.onCreatureAdded(creature);
          return creature.state.warp(creature.get("stateIdentifier"));
        });
      },
      onBuildingsReset: function() {
        var models,
          _this = this;
        models = [];
        _.each(buildings.toArray(), function(buildingModel) {
          var model;
          buildings.remove(buildingModel, {
            silent: true
          });
          switch (buildingModel.get("type")) {
            case "Home":
              model = new HomeModel(buildingModel.attributes);
              break;
            case "Farm":
              model = new FarmModel(buildingModel.attributes);
              break;
            case "Road":
              model = new RoadModel(buildingModel.attributes);
              break;
            case "Mine":
              model = new MineModel(buildingModel.attributes);
              break;
            case "LumberMill":
              model = new LumberMillModel(buildingModel.attributes);
              break;
            case "WaterWell":
              model = new WaterWellModel(buildingModel.attributes);
              break;
            case "Factory":
              model = new FactoryModel(buildingModel.attributes);
              break;
            default:
              return;
          }
          return models.push(model);
        });
        buildings.reset([], {
          silent: true
        });
        buildings.reset(models, {
          silent: true
        });
        buildings.each(function(buildingModel) {
          return _this.onBuildingAdded(buildingModel);
        });
        return buildings.each(function(buildingModel) {
          return foremanModel.informNeighbors(buildingModel);
        });
      },
      onBuildingAdded: function(buildingModel) {
        var buildingView, tileModel;
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
        buildingModel.trigger("calculateBackgroundPosition");
        tileModel = _.first(mapTiles.where({
          x: buildingModel.get("x"),
          y: buildingModel.get("y")
        }));
        return tileModel.set("buildingView", buildingView);
      }
    });
  });

}).call(this);
