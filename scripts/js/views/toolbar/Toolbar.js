(function() {

  define(["text!../../../../templates/toolbar/toolbar.html", "models/Overview", "Backbone", "Bootstrap"], function(toolbarTemplate, overviewModel) {
    var ToolbarView;
    return ToolbarView = Backbone.View.extend({
      el: ".action-toolbar",
      activeContext: "move",
      menuOption: "road",
      template: _.template(toolbarTemplate),
      events: {
        "click .btn": "onBtnClick",
        "click .dropdown-btn": "onDropdownBtnClick",
        "click .dropdown-menu .road-btn": "onRoadBtnClick",
        "click .dropdown-menu .home-btn": "onHomeBtnClick",
        "click .dropdown-menu .farm-btn": "onFarmBtnClick",
        "click .dropdown-menu .mine-btn": "onMineBtnClick",
        "click .dropdown-menu .lumber-mill-btn": "onLumberMillBtnClick",
        "click .dropdown-menu .water-well-btn": "onWaterWellBtnClick",
        "click .dropdown-menu .factory-btn": "onFactoryBtnClick",
        "click .move-btn": "onMoveBtnClick",
        "click .remove-btn": "onRemoveBtnClick",
        "click .dropdown-menu a": "onDropdownItemClick"
      },
      contextIconLookup: {
        "road": {
          icon: "road",
          label: "Road"
        },
        "home": {
          icon: "home",
          label: "House"
        },
        "farm": {
          icon: "leaf",
          label: "Farm"
        },
        "mine": {
          icon: "filter",
          label: "Mine"
        },
        "lumber mill": {
          icon: "inbox",
          label: "Lumber Mill"
        },
        "water well": {
          icon: "tint",
          label: "Water Well"
        },
        "factory": {
          icon: "cogs",
          label: "Factory"
        }
      },
      initialize: function() {
        this.listenTo(overviewModel, "change:wood", this.onResourcesChanged);
        this.listenTo(overviewModel, "change:food", this.onResourcesChanged);
        this.listenTo(overviewModel, "change:metal", this.onResourcesChanged);
        this.render();
        return this.onResourcesChanged();
      },
      render: function() {
        this.$el.html(this.template(this.contextIconLookup[this.menuOption]));
        this.$(".btn-group > ." + this.activeContext + "-btn").addClass("active btn-primary");
        this.$("[data-toggle=tooltip]").tooltip({
          container: "body",
          placement: "left",
          html: true
        });
        this.onResourcesChanged();
        return this;
      },
      onDropdownItemClick: function(jqEvent) {
        jqEvent.preventDefault();
        jqEvent.stopPropagation();
        this.$("[data-toggle=tooltip]").tooltip("hide");
        this.render();
        this.$(".dropdown-toggle, .btn-group.open").removeClass("active open");
        return this.$(".dropdown-btn").addClass("active btn-primary");
      },
      onBtnClick: function(jqEvent) {
        if ($(jqEvent.currentTarget).hasClass("dropdown-toggle")) {
          return;
        }
        this.$(".btn").removeClass("active btn-primary");
        return $(jqEvent.currentTarget).addClass("active btn-primary");
      },
      onMoveBtnClick: function() {
        return this.activeContext = "move";
      },
      onDropdownBtnClick: function() {
        return this.activeContext = this.menuOption;
      },
      onRoadBtnClick: function() {
        this.activeContext = "road";
        return this.menuOption = "road";
      },
      onHomeBtnClick: function() {
        this.activeContext = "home";
        return this.menuOption = "home";
      },
      onFarmBtnClick: function() {
        this.activeContext = "farm";
        return this.menuOption = "farm";
      },
      onMineBtnClick: function() {
        this.activeContext = "mine";
        return this.menuOption = "mine";
      },
      onLumberMillBtnClick: function() {
        this.activeContext = "lumber mill";
        return this.menuOption = "lumber mill";
      },
      onWaterWellBtnClick: function() {
        this.activeContext = "water well";
        return this.menuOption = "water well";
      },
      onFactoryBtnClick: function() {
        this.activeContext = "factory";
        return this.menuOption = "factory";
      },
      onRemoveBtnClick: function() {
        return this.activeContext = "remove";
      },
      onResourcesChanged: function() {
        this.$(".wood-count").html(overviewModel.get("wood"));
        this.$(".food-count").html(overviewModel.get("food"));
        return this.$(".metal-count").html(overviewModel.get("metal"));
      }
    });
  });

}).call(this);
