define [
      "collections/Creatures"
      "models/heightmap/Heightmap"
      "collections/MapTiles"
      "models/entities/Creature"
      "collections/Buildings"
      "models/buildings/Farm"
      "models/buildings/Road"
      "models/buildings/Home"
      "models/buildings/Mine"
      "models/buildings/LumberMill"
      "models/buildings/WaterWell"
      "models/buildings/Factory"
      "models/Overview"
      "Backbone"
    ], (
      creatures,
      heightmapModel,
      mapTiles,
      CreatureModel,
      buildings,
      FarmModel,
      RoadModel,
      HomeModel,
      MineModel,
      LumberMillModel,
      WaterWellModel,
      FactoryModel,
      overview) ->

  Foreman = Backbone.Model.extend
    removeBuilding: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      foundBuildings = buildings.where
        x: x
        y: y

      buildingModel = _.first foundBuildings

      buildings.remove buildingModel

      @informNeighbors tileModel

    putRoad: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      roadModel = new RoadModel tileModel: tileModel, x: x, y: y

      unless overview.purchase roadModel.get "cost"
        return

      buildings.add roadModel

      @informNeighbors tileModel

      @assignIdleWorkers()

    putFarm: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      farmModel = new FarmModel tileModel: tileModel, x: x, y: y

      unless overview.purchase farmModel.get "cost"
        return

      buildings.add farmModel

      @informNeighbors tileModel

      @findWorker farmModel

    putHome: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      homeModel = new HomeModel tileModel: tileModel, x: x, y: y

      unless overview.purchase homeModel.get "cost"
        return

      buildings.add homeModel

      @informNeighbors tileModel

      creatureModel = new CreatureModel x: x, y: y

      creatures.add creatureModel

      creatureModel.set "home", homeModel

      homeModel.set "creature", creatureModel

      @findJob creatureModel

    putMine: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      mineModel = new MineModel tileModel: tileModel, x: x, y: y

      unless overview.purchase mineModel.get "cost"
        return

      buildings.add mineModel

      @informNeighbors tileModel

      @findWorker mineModel

    putLumberMill: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      lumberMillModel = new LumberMillModel tileModel: tileModel, x: x, y: y

      unless overview.purchase lumberMillModel.get "cost"
        return

      buildings.add lumberMillModel

      @informNeighbors tileModel

      @findWorker lumberMillModel

    putWaterWell: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      waterWellModel = new WaterWellModel tileModel: tileModel, x: x, y: y

      unless overview.purchase waterWellModel.get "cost"
        return

      buildings.add waterWellModel

      @informNeighbors tileModel

      @findWorker waterWellModel

    putFactory: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      factoryModel = new FactoryModel tileModel: tileModel, x: x, y: y

      unless overview.purchase factoryModel.get "cost"
        return

      buildings.add factoryModel

      @informNeighbors tileModel

      @findWorker factoryModel

    assignWorkerToSite: (unemployedCreature, workSiteModel) ->
      unemployedCreature.set "workSite", workSiteModel

      workSiteModel.set "worker", unemployedCreature

    findJob: (unemployedCreature) ->
      availableJobs = buildings.where
        needsWorker: true
        worker: undefined

      if availableJobs.length is 0
        return

      _.some availableJobs, (workSiteModel) =>
        path = unemployedCreature.findPath workSiteModel

        if path.length is 0
          return false

        @assignWorkerToSite unemployedCreature, workSiteModel

        true

    assignIdleWorkers: ->
      unemployedCreatures = creatures.where
        workSite: undefined

      if unemployedCreatures.length is 0
        return

      _.some unemployedCreatures, (unemployedCreature) =>
        availableJobs = buildings.where
          needsWorker: true
          worker: undefined

        if availableJobs.length is 0
          return true

        _.some availableJobs, (workSiteModel) =>
          path = unemployedCreature.findPath workSiteModel

          if path.length is 0
            return false

          @assignWorkerToSite unemployedCreature, workSiteModel

          true

        false

    findWorker: (workSiteModel) ->
      unemployedCreatures = creatures.where
        workSite: undefined

      if unemployedCreatures.length is 0
        return

      _.some unemployedCreatures, (unemployedCreature) =>
        path = unemployedCreature.findPath workSiteModel

        if path.length is 0
          return false

        @assignWorkerToSite unemployedCreature, workSiteModel

        true

    informNeighbors: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      neighboringTiles = heightmapModel.getNeighboringTiles x, y

      _.each neighboringTiles, (neighboringTile) ->
        neighboringTile.trigger "neighborChanged"

  new Foreman
