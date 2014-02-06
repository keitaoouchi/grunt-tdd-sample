require =
  baseUrl: '/static'
  paths:
    jquery: 'vendors/jquery/jquery.min'
    underscore: 'vendors/underscore-amd/underscore-min'
    backbone: 'vendors/backbone-amd/backbone-min'
    domReady: 'vendors/requirejs-domready/domReady'
  shim:
    underscore:
      exports: '_'
    backbone:
      deps: ["jquery", "underscore"]
      exports: "Backbone"
