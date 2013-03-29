(function() {

  define(["collections/Creatures", "models/heightmap/Heightmap", "models/entities/Creature", "collections/Buildings", "models/buildings/Farm", "models/buildings/Road", "models/buildings/Home", "models/buildings/Mine", "models/buildings/LumberMill", "models/buildings/WaterWell", "models/buildings/Factory", "models/Overview", "Backbone"], function(creatures, heightmapModel, CreatureModel, buildings, FarmModel, RoadModel, HomeModel, MineModel, LumberMillModel, WaterWellModel, FactoryModel, overview) {
    var Foreman;
    Foreman = Backbone.Model.extend({
      removeBuilding: function(tileModel) {
        var buildingModel, foundBuildings, x, y;
        x = tileModel.get("x");
        y = tileModel.get("y");
        foundBuildings = buildings.where({
          x: x,
          y: y
        });
        buildingModel = _.first(foundBuildings);
        buildings.remove(buildingModel);
        return this.informNeighbors(tileModel);
      },
      putRoad: function(tileModel) {
        var roadModel, x, y;
        x = tileModel.get("x");
        y = tileModel.get("y");
        roadModel = new RoadModel({
          x: x,
          y: y
        });
        if (!overview.purchase(roadModel.get("resources"))) {
          return;
        }
        buildings.add(roadModel);
        buildings.sync('create', roadModel);
        this.informNeighbors(tileModel);
        return this.assignIdleWorkers();
      },
      putFarm: function(tileModel) {
        var farmModel, x, y;
        x = tileModel.get("x");
        y = tileModel.get("y");
        farmModel = new FarmModel({
          x: x,
          y: y
        });
        if (!overview.purchase(farmModel.get("resources"))) {
          return;
        }
        buildings.add(farmModel);
        this.informNeighbors(tileModel);
        return this.findWorker(farmModel);
      },
      putHome: function(tileModel) {
        var creatureModel, homeModel, x, y;
        x = tileModel.get("x");
        y = tileModel.get("y");
        homeModel = new HomeModel({
          x: x,
          y: y
        });
        if (!overview.purchase(homeModel.get("resources"))) {
          return;
        }
        buildings.add(homeModel);
        this.informNeighbors(tileModel);
        creatureModel = new CreatureModel({
          x: x,
          y: y
        });
        creatures.add(creatureModel);
        creatureModel.set("home", homeModel);
        homeModel.set("creature", creatureModel);
        return this.findJob(creatureModel);
      },
      putMine: function(tileModel) {
        var mineModel, x, y;
        x = tileModel.get("x");
        y = tileModel.get("y");
        mineModel = new MineModel({
          x: x,
          y: y
        });
        if (!overview.purchase(mineModel.get("resources"))) {
          return;
        }
        buildings.add(mineModel);
        this.informNeighbors(tileModel);
        return this.findWorker(mineModel);
      },
      putLumberMill: function(tileModel) {
        var lumberMillModel, x, y;
        x = tileModel.get("x");
        y = tileModel.get("y");
        lumberMillModel = new LumberMillModel({
          x: x,
          y: y
        });
        if (!overview.purchase(lumberMillModel.get("resources"))) {
          return;
        }
        buildings.add(lumberMillModel);
        this.informNeighbors(tileModel);
        return this.findWorker(lumberMillModel);
      },
      putWaterWell: function(tileModel) {
        var waterWellModel, x, y;
        x = tileModel.get("x");
        y = tileModel.get("y");
        waterWellModel = new WaterWellModel({
          x: x,
          y: y
        });
        if (!overview.purchase(waterWellModel.get("resources"))) {
          return;
        }
        buildings.add(waterWellModel);
        this.informNeighbors(tileModel);
        return this.findWorker(waterWellModel);
      },
      putFactory: function(tileModel) {
        var factoryModel, x, y;
        x = tileModel.get("x");
        y = tileModel.get("y");
        factoryModel = new FactoryModel({
          x: x,
          y: y
        });
        if (!overview.purchase(factoryModel.get("resources"))) {
          return;
        }
        buildings.add(factoryModel);
        this.informNeighbors(tileModel);
        return this.findWorker(factoryModel);
      },
      assignWorkerToSite: function(unemployedCreature, workSiteModel) {
        unemployedCreature.set("workSite", workSiteModel);
        return workSiteModel.set("worker", unemployedCreature);
      },
      findJob: function(unemployedCreature) {
        var availableJobs,
          _this = this;
        availableJobs = buildings.where({
          needsWorker: true,
          worker: void 0
        });
        if (availableJobs.length === 0) {
          return;
        }
        return _.some(availableJobs, function(workSiteModel) {
          var path;
          path = unemployedCreature.findPath(workSiteModel);
          if (path.length === 0) {
            return false;
          }
          _this.assignWorkerToSite(unemployedCreature, workSiteModel);
          return true;
        });
      },
      assignIdleWorkers: function() {
        var unemployedCreatures,
          _this = this;
        unemployedCreatures = creatures.where({
          workSite: void 0
        });
        if (unemployedCreatures.length === 0) {
          return;
        }
        return _.some(unemployedCreatures, function(unemployedCreature) {
          var availableJobs;
          availableJobs = buildings.where({
            needsWorker: true,
            worker: void 0
          });
          if (availableJobs.length === 0) {
            return true;
          }
          _.some(availableJobs, function(workSiteModel) {
            var path;
            path = unemployedCreature.findPath(workSiteModel);
            if (path.length === 0) {
              return false;
            }
            _this.assignWorkerToSite(unemployedCreature, workSiteModel);
            return true;
          });
          return false;
        });
      },
      findWorker: function(workSiteModel) {
        var unemployedCreatures,
          _this = this;
        unemployedCreatures = creatures.where({
          workSite: void 0
        });
        if (unemployedCreatures.length === 0) {
          return;
        }
        return _.some(unemployedCreatures, function(unemployedCreature) {
          var path;
          path = unemployedCreature.findPath(workSiteModel);
          if (path.length === 0) {
            return false;
          }
          _this.assignWorkerToSite(unemployedCreature, workSiteModel);
          return true;
        });
      },
      informNeighbors: function(tileModel) {
        var neighboringTiles, x, y;
        x = tileModel.get("x");
        y = tileModel.get("y");
        return neighboringTiles = heightmapModel.getNeighboringTiles(x, y);
        /*
        _.each neighboringTiles, (neighboringTile) ->
          neighboringTile.trigger "neighborChanged"
        */

      }
    });
    return new Foreman;
  });

}).call(this);
