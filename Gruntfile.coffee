true

'use strict'

module.exports = (grunt) ->
  
  require('load-grunt-tasks') grunt
  
  grunt.initConfig
    
    watch:
      coffee:
        files: ['src/js/{,*/}*.{coffee,litcoffee,coffee.md}']
        tasks: ['coffee:dist']
      coffeeTest:
        files: ['test/spec/{,*/}*.{coffee,litcoffee,coffee.md}']
        tasks: [
          'coffee:test'
        ]
      compass:
        files: ['src/{,*/}*.{scss,sass}', 'src/settings/{,*/}*.{scss,sass}', 'src/mixins/{,*/}*.{scss,sass}', 'src/style/{,*/}*.{scss,sass}']
        tasks: [
          'compass'
          'kss'
        ]
      options:
        livereload: true
        nospawn: true

    connect:
      docs:
        options:
          port: 8080
          base: 'docs/styleguide'
          open: 'http://localhost:8080/'

    clean:
      dist: [
        'dist'
      ]

    coffee:
      options:
        sourceMap: true
        sourceRoot: ''
      dist:
        files: [
          expand: true
          cwd: 'src/js'
          src: '{,*/}*.coffee'
          dest: 'dist/js'
          ext: '.js'
        ]
      test:
        files: [
          expand: true
          cwd: 'test/spec'
          src: '{,*/}*.coffee'
          dest: 'spec'
          ext: '.js'
        ]

    compass:
      options:
        sassDir: 'src'
        cssDir: 'dist/css'
        javascriptsDir: 'dist/js'
        relativeAssets: false
        assetCacheBuster: false
      dist:
        options:
          generatedImagesDir: 'dist/img'

    cssmin:
      options:
        root: 'dist/css'

    imagemin:
      dist:
        files: [
          expand: true
          cwd: 'src/img'
          src: '{,*/}*.{png,jpg,jpeg,gif}'
          dest: 'dist/img'
        ]
    
    copy:
      dist:
        files: [
          {
            expand: true
            cwd: 'src/'
            src: ['mixins/*', 'settings/*']
            dest: 'dist/'
          }
        ]

    kss:
      options:
        includeType: 'css'
        includePath: 'dist/css/zenigame.css'
      dist:
        files: 'docs/styleguide/': ['src/']

  grunt.registerTask 'build', [
    'clean:dist'
    'copy'
    'coffee'
    'compass'
    'kss'
    'cssmin'
    'imagemin'
  ]

  grunt.registerTask 'serve', [
    'build'
    'connect'
    'watch'
  ]

  grunt.registerTask 'default', [
    'build'
  ]

  return
