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
        tileModel.set("isOccupied", false);
        this.informNeighbors(buildingModel);
        buildings.sync("delete", buildingModel);
        return buildings.remove(buildingModel);
      },
      putRoad: function(tileModel) {
        var roadModel, x, y;
        x = tileModel.get("x");
        y = tileModel.get("y");
        roadModel = new RoadModel({
          x: x,
          y: y
        });
        /*
        unless overview.purchase roadModel.get "resources"
          return
        */

        buildings.add(roadModel);
        this.assignIdleWorkers();
        buildings.sync("create", roadModel);
        tileModel.set("isOccupied", true);
        return this.informNeighbors(tileModel);
      },
      putFarm: function(tileModel) {
        var farmModel, x, y;
        x = tileModel.get("x");
        y = tileModel.get("y");
        farmModel = new FarmModel({
          x: x,
          y: y
        });
        /*
        unless overview.purchase farmModel.get "resources"
          return
        */

        buildings.add(farmModel);
        tileModel.set("isOccupied", true);
        buildings.sync("create", farmModel);
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
        /*
        unless overview.purchase homeModel.get "resources"
          return
        */

        buildings.add(homeModel);
        buildings.sync("create", homeModel);
        tileModel.set("isOccupied", true);
        this.informNeighbors(tileModel);
        creatureModel = new CreatureModel({
          x: x,
          y: y
        });
        creatures.add(creatureModel);
        creatureModel.set("homeFk", homeModel.get("id"));
        creatures.sync("create", creatureModel);
        homeModel.set("creatureFk", creatureModel.get("id"));
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
        /*
        unless overview.purchase mineModel.get "resources"
          return
        */

        buildings.add(mineModel);
        tileModel.set("isOccupied", true);
        buildings.sync("create", mineModel);
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
        /*
        unless overview.purchase lumberMillModel.get "resources"
          return
        */

        buildings.add(lumberMillModel);
        tileModel.set("isOccupied", true);
        buildings.sync("create", lumberMillModel);
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
        /*
        unless overview.purchase waterWellModel.get "resources"
          return
        */

        buildings.add(waterWellModel);
        tileModel.set("isOccupied", true);
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
        /*
        unless overview.purchase factoryModel.get "resources"
          return
        */

        buildings.add(factoryModel);
        tileModel.set("isOccupied", true);
        this.informNeighbors(tileModel);
        return this.findWorker(factoryModel);
      },
      assignWorkerToSite: function(unemployedCreature, workSiteModel) {
        unemployedCreature.set("workSiteFk", workSiteModel.get("id"));
        workSiteModel.set("workerFk", unemployedCreature.get("id"));
        creatures.sync("update", unemployedCreature);
        return buildings.sync("update", workSiteModel);
      },
      findJob: function(unemployedCreature) {
        var availableJobs,
          _this = this;
        availableJobs = buildings.where({
          needsWorker: true,
          workerFk: void 0
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
          workSiteFk: void 0
        });
        if (unemployedCreatures.length === 0) {
          return;
        }
        return _.some(unemployedCreatures, function(unemployedCreature) {
          var availableJobs;
          availableJobs = buildings.where({
            needsWorker: true,
            workerFk: void 0
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
          workSiteFk: void 0
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
      informNeighbors: function(buildingModel) {
        var neighboringTiles, x, y;
        x = buildingModel.get("x");
        y = buildingModel.get("y");
        neighboringTiles = heightmapModel.getNeighboringTiles(x, y);
        return _.each(neighboringTiles, function(neighboringTile) {
          neighboringTile.trigger("neighborChanged");
          buildingModel = _.first(buildings.where({
            x: neighboringTile.get("x"),
            y: neighboringTile.get("y")
          }));
          if (buildingModel != null) {
            return buildingModel.trigger("neighborChanged");
          }
        });
      }
    });
    return new Foreman;
  });

}).call(this);
