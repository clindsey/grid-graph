// Generated by CoffeeScript 1.4.0
(function() {

  define(["models/entities/Entity", "models/heightmap/Heightmap", "AStar", "Machine", "Backbone"], function(EntityModel, heightmapModel, AStar) {
    var Creature;
    return Creature = EntityModel.extend({
      defaults: {
        path: [],
        workSite: void 0,
        home: void 0
      },
      initialize: function() {
        var machine,
          _this = this;
        machine = new Machine;
        this.set("direction", "south");
        this.set("state", machine.generateTree(this.behaviorTree, this, this.states));
        return this.listenTo(this, "tick", function() {
          return _this.set("state", _this.get("state").tick());
        });
      },
      findPath: function(tileModel) {
        var deltaX, deltaY, end, grid, index, lastStep, path, pathOut, pathStep, start, targetX, targetY, worldHalfHeight, worldHalfWidth, worldTileHeight, worldTileWidth, x, y, _i, _len;
        x = this.get("x");
        y = this.get("y");
        worldTileWidth = heightmapModel.get("worldTileWidth");
        worldTileHeight = heightmapModel.get("worldTileHeight");
        grid = heightmapModel.getPathfindingGrid(worldTileWidth, worldTileHeight, x, y);
        worldHalfWidth = Math.ceil(worldTileWidth / 2);
        worldHalfHeight = Math.ceil(worldTileHeight / 2);
        deltaX = x - worldHalfWidth;
        deltaY = y - worldHalfHeight;
        targetX = heightmapModel.clampX(tileModel.get("x") - deltaX);
        targetY = heightmapModel.clampY(tileModel.get("y") - deltaY);
        start = [worldHalfWidth, worldHalfHeight];
        end = [targetX, targetY];
        path = AStar(grid, start, end);
        if (path.length === 0) {
          return [];
        }
        pathOut = [];
        for (index = _i = 0, _len = path.length; _i < _len; index = ++_i) {
          pathStep = path[index];
          if (index === 0) {
            continue;
          } else {
            lastStep = path[index - 1];
            pathOut.push([pathStep[0] - lastStep[0], pathStep[1] - lastStep[1]]);
          }
        }
        pathOut.push([0, 0]);
        return pathOut;
      },
      behaviorTree: {
        identifier: "sleep",
        strategy: "sequential",
        children: [
          {
            identifier: "sleep"
          }, {
            identifier: "walk"
          }, {
            identifier: "water",
            strategy: "sequential",
            children: [
              {
                identifier: "water"
              }, {
                identifier: "walk"
              }
            ]
          }
        ]
      },
      states: {
        sleep: function() {
          var path, workSiteModel;
          workSiteModel = this.get("workSite");
          if (workSiteModel == null) {
            return;
          }
          path = this.findPath(workSiteModel);
          if (path.length === 0) {
            return;
          }
          return this.set("path", path);
        },
        canSleep: function() {
          var homeModel, homeX, homeY, path, x, y;
          path = this.get("path");
          if ((this.get("home") != null) === false || (this.get("workSite") != null) === false) {
            if (path.length === 0) {
              return true;
            }
          }
          if (path.length !== 0) {
            return false;
          }
          homeModel = this.get("home");
          if (homeModel == null) {
            return false;
          }
          homeX = homeModel.get("x");
          homeY = homeModel.get("y");
          x = this.get("x");
          y = this.get("y");
          return x === homeX && y === homeY;
        },
        walk: function() {
          var direction, nearRoad, path;
          path = this.get("path");
          nearRoad = path.shift();
          this.set("path", path);
          if (!((nearRoad != null) && !!nearRoad.length)) {
            return;
          }
          this.trigger("step", nearRoad);
          this.set({
            "x": heightmapModel.clampX(this.get("x") + nearRoad[0]),
            "y": heightmapModel.clampY(this.get("y") + nearRoad[1])
          });
          direction = "south";
          if (nearRoad[0] === 1) {
            direction = "east";
          }
          if (nearRoad[0] === -1) {
            direction = "west";
          }
          if (nearRoad[1] === 1) {
            direction = "south";
          }
          if (nearRoad[1] === -1) {
            direction = "north";
          }
          return this.set("direction", direction);
        },
        canWalk: function() {
          return !!this.get("path").length;
        },
        water: function() {
          var homeModel, path;
          homeModel = this.get("home");
          path = this.findPath(homeModel);
          if (path.length === 0) {
            return;
          }
          this.get("workSite").trigger("worked");
          return this.set("path", path);
        },
        canWater: function() {
          var homeModel, path, workSiteModel, workX, workY, x, y;
          path = this.get("path");
          if (path.length !== 0) {
            return false;
          }
          workSiteModel = this.get("workSite");
          if (workSiteModel == null) {
            homeModel = this.get("home");
            path = this.findPath(homeModel);
            if (path.length <= 1) {
              return false;
            }
            this.set("path", path);
            this.set("state", this.get("state").warp("water"));
            return false;
          }
          workX = workSiteModel.get("x");
          workY = workSiteModel.get("y");
          x = this.get("x");
          y = this.get("y");
          return x === workX && y === workY;
        }
      }
    });
  });

}).call(this);
