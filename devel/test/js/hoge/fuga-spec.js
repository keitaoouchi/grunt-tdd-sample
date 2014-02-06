require(['js/hoge/fuga', 'backbone', 'mocha', 'chai', 'sinon'], function(App, Backbone, mocha, chai, sinon) {
  'use strict';
  mocha.ui('bdd');
  chai.should();
  describe('App', function() {
    it('App.Models.FugaはBackbone.Modelを継承', function() {
      return App.Models.Fuga.prototype.should.be.an["instanceof"](Backbone.Model);
    });
    it('App.Collections.FugasはBackbone.Collectionを継承', function() {
      return App.Collections.Fugas.prototype.should.be.an["instanceof"](Backbone.Collection);
    });
    return it('App.Views.FugaViewはBackbone.Viewを継承', function() {
      return App.Views.FugaView.prototype.should.be.an["instanceof"](Backbone.View);
    });
  });
  describe('App.Models.Fuga', function() {
    var fuga;
    fuga = null;
    before(function() {
      return fuga = new App.Models.Fuga({
        name: 'fuga'
      });
    });
    return it('fugaのnameがfuga', function() {
      return fuga.name.should.be.equals('fuga');
    });
  });
  describe('App.View.FugaView', function() {
    return it('初期化時にcollectionをfetchする', function() {
      var iamspy;
      iamspy = new App.Collections.Fugas();
      iamspy.fetch = sinon.spy();
      new App.Views.FugaView({
        collection: iamspy
      });
      return iamspy.fetch.called.should.be["true"];
    });
  });
  return mocha.run();
});
