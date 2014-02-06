module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-express-server'
  grunt.loadNpmTasks 'grunt-notify'
  grunt.loadNpmTasks 'grunt-exec'

  grunt.initConfig(

    notify_hooks:
      options:
        enabled: true

    exec:
      bundle:
        command: 'bundle'
      bower:
        command: 'rm -rf ./../static/vendors && bower install'

    express:
      dev:
        options:
          script: 'test/server.js'

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

    watch:
      devel:
        files: ['test/coffee/**/*.coffee', 'test/sass/**/*.sass', 'coffee/**/*.coffee', 'sass/**/*.sass']
        tasks: ['compass:dev', 'compass:test', 'coffee:devel']
      options:
        nospawn: false
        livereload: true
  )

  grunt.registerTask 'default', ['coffee:devel', 'compass:dev', 'compass:test', 'express:dev', 'watch:devel']
  grunt.registerTask 'compile', ['exec:bundle', 'exec:bower', 'coffee:devel', 'compass:dev']
  grunt.registerTask 'setup', ['exec:bundle', 'exec:bower']
