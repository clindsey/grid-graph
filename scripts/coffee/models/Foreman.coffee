define [
      "collections/Creatures"
      "models/heightmap/Heightmap"
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

      roadModel = new RoadModel x: x, y: y

      unless overview.purchase roadModel.get "resources"
        return

      buildings.add roadModel

      buildings.sync 'create', roadModel

      @informNeighbors tileModel

      @assignIdleWorkers()

    putFarm: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      farmModel = new FarmModel x: x, y: y

      unless overview.purchase farmModel.get "resources"
        return

      buildings.add farmModel

      @informNeighbors tileModel

      @findWorker farmModel

    putHome: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      homeModel = new HomeModel x: x, y: y

      unless overview.purchase homeModel.get "resources"
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

      mineModel = new MineModel x: x, y: y

      unless overview.purchase mineModel.get "resources"
        return

      buildings.add mineModel

      @informNeighbors tileModel

      @findWorker mineModel

    putLumberMill: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      lumberMillModel = new LumberMillModel x: x, y: y

      unless overview.purchase lumberMillModel.get "resources"
        return

      buildings.add lumberMillModel

      @informNeighbors tileModel

      @findWorker lumberMillModel

    putWaterWell: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      waterWellModel = new WaterWellModel x: x, y: y

      unless overview.purchase waterWellModel.get "resources"
        return

      buildings.add waterWellModel

      @informNeighbors tileModel

      @findWorker waterWellModel

    putFactory: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      factoryModel = new FactoryModel x: x, y: y

      unless overview.purchase factoryModel.get "resources"
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

      ###
      _.each neighboringTiles, (neighboringTile) ->
        neighboringTile.trigger "neighborChanged"
      ###

  new Foreman
