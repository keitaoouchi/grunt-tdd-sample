require(['js/hoge/fuga', 'backbone', 'mocha', 'chai', 'sinon'], (App, Backbone, mocha, chai, sinon) ->
  'use strict'

  mocha.ui 'bdd'

  chai.should()

  describe 'App', ->
    it 'App.Models.FugaはBackbone.Modelを継承', ->
      App.Models.Fuga.prototype.should.be.an.instanceof Backbone.Model
    it 'App.Collections.FugasはBackbone.Collectionを継承', ->
      App.Collections.Fugas.prototype.should.be.an.instanceof Backbone.Collection
    it 'App.Views.FugaViewはBackbone.Viewを継承', ->
      App.Views.FugaView.prototype.should.be.an.instanceof Backbone.View

  describe 'App.Models.Fuga', ->

    fuga = null
    before ->
      fuga = new App.Models.Fuga({name: 'fuga'})

    it 'fugaのnameがfuga', ->
      fuga.name.should.be.equals 'fuga'

  describe 'App.View.FugaView', ->

    it '初期化時にcollectionをfetchする', ->
      iamspy = new App.Collections.Fugas()
      iamspy.fetch = sinon.spy()
      new App.Views.FugaView collection: iamspy
      iamspy.fetch.called.should.be.true

  mocha.run()

)