define(
  'js/hoge/fuga',
  ['jquery', 'underscore', 'backbone'],
  ($, _, Backbone) ->
    'use strict'

    App =
      Models: {}
      Collections: {}
      Views: {}

    class App.Models.Fuga extends Backbone.Model

      initialize: (obj) ->
        @name = obj.name

    class App.Collections.Fugas extends Backbone.Collection

      model: App.Models.Fuga

    class App.Views.FugaView extends Backbone.View

      initialize: ->
        @listenTo(@collection, 'sync', @render)
        @collection.fetch()

      render: ->

    App.initialize = ->


    if Object.freeze? then Object.freeze App else App
)