(function() {

  define(["Alea", "Backbone"], function() {
    var NameMaker;
    NameMaker = Backbone.Model.extend({
      getName: function(seed) {
        var name, syllableCount;
        this.random = new Alea(seed);
        syllableCount = ~~(this.random() * 3) + 2;
        name = this.generateName(syllableCount);
        while (this.isSensibleName(name) !== true) {
          name = this.generateName(syllableCount);
        }
        name = name.split("");
        name[0] = name[0].toUpperCase();
        return name.join("");
      },
      generateName: function(syllableCount) {
        var i, name, _i;
        name = [];
        for (i = _i = 1; 1 <= syllableCount ? _i <= syllableCount : _i >= syllableCount; i = 1 <= syllableCount ? ++_i : --_i) {
          name.push(this.digraphs[~~(this.random() * this.digraphs.length)]);
        }
        if (this.random() > 0.5) {
          name.push(this.digraphs[~~(this.random() * this.digraphs.length)]);
        } else {
          name.push(this.trigraphs[~~(this.random() * this.trigraphs.length)]);
        }
        return name.join("");
      },
      isSensibleName: function(name) {
        return name.match(/.*[aeiou]{3}.*/i) != null;
      },
      digraphs: ["a", "ac", "ad", "ar", "as", "at", "ax", "ba", "bi", "bo", "ce", "ci", "co", "de", "di", "e", "ed", "en", "es", "ex", "fa", "fo", "ga", "ge", "gi", "gu", "ha", "he", "in", "is", "it", "ju", "ka", "ky", "la", "le", "le", "lo", "mi", "mo", "na", "ne", "ne", "ni", "no", "o", "ob", "oi", "ol", "on", "or", "or", "os", "ou", "pe", "pi", "po", "qt", "re", "ro", "sa", "se", "so", "ta", "te", "ti", "to", "tu", "ud", "um", "un", "us", "ut", "va", "ve", "ve", "za", "zi"],
      trigraphs: ["cla", "clu", "cra", "cre", "dre", "dro", "pha", "phi", "pho", "sha", "she", "sta", "stu", "tha", "the", "thi", "thy", "tri"]
    });
    return new NameMaker;
  });

}).call(this);
