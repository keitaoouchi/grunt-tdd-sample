var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define('js/hoge/fuga', ['jquery', 'underscore', 'backbone'], function($, _, Backbone) {
  'use strict';
  var App, _ref, _ref1, _ref2;
  App = {
    Models: {},
    Collections: {},
    Views: {}
  };
  App.Models.Fuga = (function(_super) {
    __extends(Fuga, _super);

    function Fuga() {
      _ref = Fuga.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Fuga.prototype.initialize = function(obj) {
      return this.name = obj.name;
    };

    return Fuga;

  })(Backbone.Model);
  App.Collections.Fugas = (function(_super) {
    __extends(Fugas, _super);

    function Fugas() {
      _ref1 = Fugas.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    Fugas.prototype.model = App.Models.Fuga;

    return Fugas;

  })(Backbone.Collection);
  App.Views.FugaView = (function(_super) {
    __extends(FugaView, _super);

    function FugaView() {
      _ref2 = FugaView.__super__.constructor.apply(this, arguments);
      return _ref2;
    }

    FugaView.prototype.initialize = function() {
      this.listenTo(this.collection, 'sync', this.render);
      return this.collection.fetch();
    };

    FugaView.prototype.render = function() {};

    return FugaView;

  })(Backbone.View);
  App.initialize = function() {};
  if (Object.freeze != null) {
    return Object.freeze(App);
  } else {
    return App;
  }
});
