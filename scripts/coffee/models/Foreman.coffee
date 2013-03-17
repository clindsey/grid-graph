define [
      "collections/Creatures"
      "models/heightmap/Heightmap"
      "collections/MapTiles"
      "models/entities/Creature"
      "collections/Buildings"
      "models/buildings/Farm"
      "models/buildings/Road"
      "models/buildings/Home"
      "Backbone"
    ], (
      creatures,
      heightmapModel,
      mapTiles,
      CreatureModel,
      buildings,
      FarmModel,
      RoadModel,
      HomeModel) ->

  Foreman = Backbone.Model.extend
    defaults:
      money: 250

    initialize: ->
      @listenTo buildings, "madeMoney", @onAddMoney

    onAddMoney: (amount) ->
      money = @get "money"

      money += amount

      @set "money", money

    removeMoney: (amount) ->
      money = @get "money"

      money -= amount

      @set "money", money

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

      if @get("money") < roadModel.get("cost")
        return

      @removeMoney roadModel.get "cost"

      buildings.add roadModel

      @informNeighbors tileModel

      @assignIdleWorkers()

    putFarm: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      farmModel = new FarmModel tileModel: tileModel, x: x, y: y

      if @get("money") < farmModel.get("cost")
        return

      @removeMoney farmModel.get "cost"

      buildings.add farmModel

      @informNeighbors tileModel

      @findWorker farmModel

    putHome: (tileModel) ->
      x = tileModel.get "x"
      y = tileModel.get "y"

      homeModel = new HomeModel tileModel: tileModel, x: x, y: y

      if @get("money") < homeModel.get("cost")
        return

      @removeMoney homeModel.get "cost"

      buildings.add homeModel

      @informNeighbors tileModel

      creatureModel = new CreatureModel x: x, y: y

      creatures.add creatureModel

      creatureModel.set "home", homeModel

      homeModel.set "creature", creatureModel

      @findJob creatureModel

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
