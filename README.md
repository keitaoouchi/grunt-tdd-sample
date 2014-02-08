# RequireJSなコードをCoffeeScriptで書きつつmocha, chaiでTDDするための環境構築とGruntfile.coffee

## 目標
* CoffeeScriptで書きたいので*.cofeeをウォッチして自動でコンパイルさせたい
* Sassとかも使いたい
* mochaをブラウザで走らせたいのでテスト用のサーバーをexpressで構築する
* LiveReloadでテスト用のページを更新させる
* 以上のタスクをgruntコマンド一発で立ち上げたい
* その環境構築をnpm installを含む最低限の準備で済ませたい

## 構成方針
```
.
├── devel
│   ├── coffee
│   ├── node_modules
│   ├── sass
│   └── test
│       ├── coffee
│       └── js
└── static
    ├── css
    ├── img
    ├── js
    └── vendors
```

コンパイルすっと
devel/cofee -> static/js
devel/sass -> static/css
test/coffee -> test/js
に自動的に配置されるようにする。

devel/node_modulsはgruntで使うモジュール、static/vendorsにはbowerでインストールする3rdパーティーのファイル。

## サンプルソース

https://github.com/keitaoouchi/grunt-tdd-sample

## 試す

事前にbunlder、bowerの導入が必要。

```bash
npm install -g bower grunt-cli
```

```bash
gem install bundler
```

```bash
git clone https://github.com/keitaoouchi/grunt-tdd-sample
cd grunt-tdd-sample/devel
npm install
grunt setup
grunt
```

そして
http://localhost:3000/hoge/fuga
へ。

## gruntの環境を作るためのpackage.json
devel以下に配置してnpm install

```json:package.json
{
  "name": "static",
  "version": "0.0.1",
  "devDependencies": {
    "grunt": "~0.4.1",
    "grunt-contrib-compress": "~0.5.1",
    "grunt-contrib-watch": "~0.5.1",
    "grunt-contrib-coffee": "~0.7.0",
    "grunt-notify": "~0.2.7",
    "grunt-contrib-compass": "~0.5.0",
    "grunt-express-server": "~0.4.2",
    "grunt-exec": "~0.4.2",
    "express": "~3.3.4",
    "jade": "~0.34.1",
    "mocha": "~1.12.0",
    "sinon": "~1.7.3",
    "chai": "~1.7.2"
  },
  "directories": {
    "test": "test"
  }
}
```

## compass/sassを導入するためのGemfile
導入はgruntにやらせるのでGemfileをdevel直下に貼るだけ

```ruby:Gemfile
source 'http://rubygems.org'

gem 'sass'
gem 'compass'
```

## bowerで導入する3rdパーテーのライブラリをstatic/vendorsに配置する.bowerrc
devel直下に配置

```json:.bowerrc
{
  "directory": "./../static/vendors"
}
```

## bowerで導入するためのbower.jsonの一例
devel直下に配置する

```json:bower.json
{
  "name": "static",
  "version": "0.0.1",
  "ignore": [
    "**/.*",
    "node_modules",
    "components"
  ],
  "dependencies": {
    "jquery": "~2.0.0",
    "backbone-amd": "~1.0.0",
    "requirejs-domready": "~2.0.1",
    "requirejs": "~2.1.5",
    "underscore-amd": "~1.4.4"
  },
  "devDependencies": {
    "mocha": "~1.11.0",
    "chai": "~1.6.1",
    "sinon": "http://sinonjs.org/releases/sinon-1.7.1.js"
  }
}
```

## Gruntfile.coffee
やはりdevel直下に配置

```coffeescript:Gruntfile.coffee
module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-express-server'
  grunt.loadNpmTasks 'grunt-notify'
  grunt.loadNpmTasks 'grunt-exec'

  grunt.initConfig(

    #構文エラーとかあって失敗すると通知する
    notify_hooks:
      options:
        enabled: true

    #compass/sass導入とbower installする
    exec:
      bundle:
        command: 'bundle'
      bower:
        command: 'rm -rf ./../static/vendors && bower install'

    #expressでテスト用サーバーを立ち上げる
    express:
      dev:
        options:
          script: 'test/server.js'

    #devel/coffee => static/js、devel/test/coffee => devel/test/js
    coffee:
      devel:
        options:
          bare: true
        files: [
          {
            expand: true
            cwd: './coffee'
            src: '**/*.coffee'
            dest: './../static/js'
            ext: '.js'
          },
          {
            expand: true
            cwd: './test/coffee'
            src: '**/*.coffee'
            dest: './test/js'
            ext: '.js'
          }
        ]

    #sassつかう
    compass:
      dev:
        options:
          bundleExec: true
          sassDir: 'sass'
          cssDir: './../static/css'
      test:
        options:
          bundleExec: true
          sassDir: 'test/sass'
          cssDir: 'test/css'

    #監視: 一個でも変更あったら全部コンパイルし直しててダサし
    watch:
      devel:
        files: ['test/coffee/**/*.coffee', 'test/sass/**/*.sass', 'coffee/**/*.coffee', 'sass/**/*.sass']
        tasks: ['compass:dev', 'compass:test', 'coffee:devel']
      options:
        # 死んでも死なないようにする
        nospawn: false
        # 嬉しい
        livereload: true
  )

  #環境作ってコンパイルしてサーバーたちあげて監視体制に入る
  grunt.registerTask 'default', ['coffee:devel', 'compass:dev', 'compass:test', 'express:dev', 'watch:devel']
  #環境作ってコンパイルする
  grunt.registerTask 'compile', ['exec:bundle', 'exec:bower', 'coffee:devel', 'compass:dev']
  #環境作るだけ
  grunt.registerTask 'setup', ['exec:bundle', 'exec:bower']
```

## devel/test/server.js

mochaをブラウザで走らせるためのサーバーをexpressで簡単に。

```js:test/server.js
var express = require('express');
var http = require('http');

var app = express();

app.configure(function(){
  app.set('port', process.env.PORT || 8080);
  app.set('view engine', 'jade');
  app.use(express.static('./../'));
});


app.get(/(.+)(\/.+)?/, function(req, res){
  var path = req.params[0].replace('/', '');
  res.render(__dirname + '/template', {target: path});
});

http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});
```

gruntのwatchタスクで監視されてるので、devel/test以下にcoffee/hoge/fuga-spec.coffeeとか作っとくとfuga-spec.coffeeが更新されるたびにjs/hoge/fuga-spec.jsにコンパイルされて、上記サーバーが稼働してるのでlocalhost:3000/hoge/fugaにアクセスするとブラウザにテスト結果が表示されるとともにLiveReloadでコンパイル次のテスト結果が随時更新される。

## require.jsの設定ファイルをcoffeeで書く

```coffeescript:devel/coffee/config.coffee
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
```

```coffeescript:devel/test/coffee/spec-config.coffee
require_test =
  paths:
    mocha: 'vendors/mocha/mocha'
    chai: 'vendors/chai/chai'
    sinon: 'vendors/sinon/index'
  shim:
    mocha:
      exports: 'mocha'
    chai:
      exports: 'chai'
    sinon:
      exports: 'sinon'

require = window.require || {}

for key, val of require_test.paths
  require.paths[key] = val
for key, val of require_test.shim
  require.shim[key] = val
```

## テスト対象となるモジュール例

ものすごくどうでもいい感じのモジュールをRequirejsで作ります。

```coffeescript:devel/hoge/fuga.coffee
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
```

## モジュールをテストするspec例

```coffeescript:devel/test/coffee/hoge/fuga-spec.coffee
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
```

## mochaで結果を表示するためのjadeテンプレ

```jade:template.jade
doctype 5
html
  head
    title (^q^) < #{target} のてすと
    link(rel='stylesheet', href='/static/vendors/mocha/mocha.css')
    link(rel='stylesheet', href='/devel/test/css/style.css')

  body
    div(class='title')
      h1 (^q^) < #{target} のてすと
    div(id='mocha')
    script(src='/static/js/config.js')
    script(src='/devel/test/js/spec-config.js')
    script(src='/static/vendors/requirejs/require.js')
    script(src='/devel/test/js/#{target}-spec.js')
```



