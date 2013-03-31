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

      tileModel.set "isOccupied", false

      @informNeighbors buildingModel

      buildings.sync "delete", buildingModel

      buildings.remove buildingModel

    putRoad: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      roadModel = new RoadModel x: x, y: y

      ###
      unless overview.purchase roadModel.get "resources"
        return
      ###

      buildings.add roadModel

      @assignIdleWorkers()

      buildings.sync "create", roadModel

      tileModel.set "isOccupied", true

      @informNeighbors tileModel

    putFarm: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      farmModel = new FarmModel x: x, y: y

      ###
      unless overview.purchase farmModel.get "resources"
        return
      ###

      buildings.add farmModel

      tileModel.set "isOccupied", true

      buildings.sync "create", farmModel

      @informNeighbors tileModel

      @findWorker farmModel

    putHome: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      homeModel = new HomeModel x: x, y: y

      ###
      unless overview.purchase homeModel.get "resources"
        return
      ###

      buildings.add homeModel

      buildings.sync "create", homeModel

      tileModel.set "isOccupied", true

      @informNeighbors tileModel

      creatureModel = new CreatureModel x: x, y: y

      creatures.add creatureModel

      creatureModel.set "homeFk", homeModel.get "id"

      creatures.sync "create", creatureModel

      homeModel.set "creatureFk", creatureModel.get "id"

      @findJob creatureModel

    putMine: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      mineModel = new MineModel x: x, y: y

      ###
      unless overview.purchase mineModel.get "resources"
        return
      ###

      buildings.add mineModel

      tileModel.set "isOccupied", true

      buildings.sync "create", mineModel

      @informNeighbors tileModel

      @findWorker mineModel

    putLumberMill: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      lumberMillModel = new LumberMillModel x: x, y: y

      ###
      unless overview.purchase lumberMillModel.get "resources"
        return
      ###

      buildings.add lumberMillModel

      tileModel.set "isOccupied", true

      buildings.sync "create", lumberMillModel

      @informNeighbors tileModel

      @findWorker lumberMillModel

    putWaterWell: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      waterWellModel = new WaterWellModel x: x, y: y

      ###
      unless overview.purchase waterWellModel.get "resources"
        return
      ###

      buildings.add waterWellModel

      tileModel.set "isOccupied", true

      @informNeighbors tileModel

      @findWorker waterWellModel

    putFactory: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      factoryModel = new FactoryModel x: x, y: y

      ###
      unless overview.purchase factoryModel.get "resources"
        return
      ###

      buildings.add factoryModel

      tileModel.set "isOccupied", true

      @informNeighbors tileModel

      @findWorker factoryModel

    assignWorkerToSite: (unemployedCreature, workSiteModel) ->
      unemployedCreature.set "workSiteFk", workSiteModel.get "id"

      workSiteModel.set "workerFk", unemployedCreature.get "id"

      creatures.sync "update", unemployedCreature
      buildings.sync "update", workSiteModel

    findJob: (unemployedCreature) ->
      availableJobs = buildings.where
        needsWorker: true
        workerFk: undefined

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
        workSiteFk: undefined

      if unemployedCreatures.length is 0
        return

      _.some unemployedCreatures, (unemployedCreature) =>
        availableJobs = buildings.where
          needsWorker: true
          workerFk: undefined

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
        workSiteFk: undefined

      if unemployedCreatures.length is 0
        return

      _.some unemployedCreatures, (unemployedCreature) =>
        path = unemployedCreature.findPath workSiteModel

        if path.length is 0
          return false

        @assignWorkerToSite unemployedCreature, workSiteModel

        true

    informNeighbors: (buildingModel) ->
      x = buildingModel.get "x"
      y = buildingModel.get "y"

      neighboringTiles = heightmapModel.getNeighboringTiles x, y

      _.each neighboringTiles, (neighboringTile) ->
        neighboringTile.trigger "neighborChanged"
        buildingModel = _.first buildings.where
          x: neighboringTile.get "x"
          y: neighboringTile.get "y"

        buildingModel.trigger("neighborChanged") if buildingModel?

  new Foreman
