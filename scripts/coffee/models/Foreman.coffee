define [
      "collections/Creatures"
      "models/Heightmap"
      "collections/MapTiles"
      "Backbone"
    ], (
      creatures,
      heightmapModel,
      mapTiles) ->

  Foreman = Backbone.Model.extend
    assignWorkerToSite: (unemployedCreature, workSiteModel) ->
      unemployedCreature.set "workSite", workSiteModel

      workSiteModel.set "worker", unemployedCreature

    findJob: (unemployedCreature) ->
      availableJobs = mapTiles.where
        buildingType: 3
        worker: undefined

      if availableJobs.length is 0
        return

      workSiteModel = availableJobs[0]

      path = unemployedCreature.findPath workSiteModel

      if path.length is 0
        return

      @assignWorkerToSite unemployedCreature, workSiteModel

    findWorker: (workSiteModel) ->
      unemployedCreatures = creatures.where
        workSite: undefined

      if unemployedCreatures.length is 0
        return

      unemployedCreature = unemployedCreatures[0]

      path = unemployedCreature.findPath workSiteModel

      if path.length is 0
        return

      @assignWorkerToSite unemployedCreature, workSiteModel

  new Foreman
