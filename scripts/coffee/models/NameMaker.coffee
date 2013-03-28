define [
      "Alea"
      "Backbone"
    ], (
      ) ->

  NameMaker = Backbone.Model.extend
    getName: (seed) ->
      @random = new Alea(seed)

      syllableCount = ~~(@random() * 3) + 2
      name = @generateName syllableCount

      while @isSensibleName(name) isnt true
        name = @generateName syllableCount

      name = name.split ""
      name[0] = name[0].toUpperCase()

      name.join ""

    generateName: (syllableCount) ->
      name = []

      for i in [1..syllableCount]
        name.push @digraphs[~~(@random() * @digraphs.length)]

      if @random() > 0.5
        name.push @digraphs[~~(@random() * @digraphs.length)]
      else
        name.push @trigraphs[~~(@random() * @trigraphs.length)]

      name.join ""

    isSensibleName: (name) ->
      name.match(/.*[aeiou]{3}.*/i)?

    digraphs: [
      "a", "ac", "ad", "ar", "as", "at", "ax", "ba", "bi", "bo", "ce", "ci",
      "co", "de", "di", "e", "ed", "en", "es", "ex", "fa", "fo", "ga", "ge",
      "gi", "gu", "ha", "he", "in", "is", "it", "ju", "ka", "ky", "la", "le",
      "le", "lo", "mi", "mo", "na", "ne", "ne", "ni", "no", "o", "ob", "oi",
      "ol", "on", "or", "or", "os", "ou", "pe", "pi", "po", "qt", "re", "ro",
      "sa", "se", "so", "ta", "te", "ti", "to", "tu", "ud", "um", "un", "us",
      "ut", "va", "ve", "ve", "za", "zi"
    ]

    trigraphs: [
      "cla", "clu", "cra", "cre", "dre", "dro", "pha", "phi", "pho", "sha",
      "she", "sta", "stu", "tha", "the", "thi", "thy", "tri"
    ]

  new NameMaker
