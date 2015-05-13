'use strict'

gulp = require 'gulp'
$ = (require 'gulp-load-plugins')()
browserify = require 'browserify'
browserSync = require 'browser-sync'
gutil = require 'gulp-util'
del = require 'del'
exec = require('child_process').exec
markdown = require 'gulp-markdown'
jade = require 'gulp-jade'
mainBowerFiles = require 'main-bower-files'
runSequence = require 'run-sequence'
source = require 'vinyl-source-stream'

dirs =
  src: './docs'
  dist: './dist'

paths =
  md: ["#{dirs.src}/md/**/*.md"]
  jade: ["#{dirs.src}/templates/**/!(_)*.jade"]
  coffee: ["#{dirs.src}/static/coffee/**/*.coffee"]
  browserify: ["#{dirs.src}/static/coffee/base.coffee"]
  sass: ["#{dirs.src}/static/sass/**/*.scss"]
  image: ["#{dirs.src}/static/img/**/*.{png,jpg,gif}"]

###
# Markdown
###

# md -> HTML 変換
gulp.task 'md', ->
  gulp.src paths.md
    .pipe markdown()
    .pipe gulp.dest "#{dirs.src}/templates/contents/"

# HTML生成
gulp.task 'prodMd', (cb) ->
  runSequence 'md', cb


###
# Jade
###

# Jade -> HTML 変換
gulp.task 'jade', ->
    YOUR_LOCALS = {}
    gulp.src paths.jade
      .pipe jade
        locals: YOUR_LOCALS
      .pipe gulp.dest "#{dirs.dist}"

# HTML生成
gulp.task 'prodJade', (cb) ->
  runSequence 'jade', cb


###
# Image
###

# 画像の最適化
gulp.task 'image', ->
  gulp.src paths.image
    .pipe plumberWithNotify()
    .pipe $.using()
    .pipe $.imagemin
      optimizationLevel: 1
    .pipe $.size()
    .pipe gulp.dest "#{dirs.dist}/img/"


###
# CSS
###

# SCSS -> CSS 変換
gulp.task 'sass', ->
  gulp.src paths.sass
    .pipe plumberWithNotify()
    #.pipe $.cached()
    .pipe $.using()
    .pipe $.compass
      css: "#{dirs.dist}/css"
      sass: "#{dirs.src}/static/sass"
    .pipe $.size()
    .pipe gulp.dest "#{dirs.dist}/css/"

# CSS 圧縮
gulp.task 'optimizeCSS', ->
  gulp.src ["#{dirs.dist}/css/**/*{.*,}[^.min].css"]
    .pipe $.cssmin noAdvanced: true
    .pipe $.size title: 'minify'
    .pipe $.rename extname: '.min.css'
    .pipe gulp.dest "#{dirs.dist}/css/"

# CSS 生成・圧縮
gulp.task 'prodCSS', (cb) ->
  runSequence 'sass', 'optimizeCSS', cb


###
# JS
###

# JS 生成 (browserify)
gulp.task 'js', ->
  browserify
    entries: paths.browserify
    extensions: ['.coffee', '.js']
  .bundle()
  .pipe source "base.js"
  .pipe gulp.dest "#{dirs.dist}/js/"

# JS 最適化
gulp.task 'optimizeJS', ->
  gulp.src ["#{dirs.dist}/js/**/*{.*,}[^.min].js"]
    .pipe $.using()
    .pipe $.size()
    .pipe $.uglify()
    .pipe $.size title: 'minify'
    .pipe $.rename extname: '.min.js'
    .pipe gulp.dest "#{dirs.dist}/js/"

# 本番用 JS 生成
gulp.task 'prodJS', (cb) ->
  runSequence 'js', 'optimizeJS', cb


###
# Util
###
# 本番判定
isProduction = ->
  process.env.ENV is 'production'

# エラー制御とNotify
plumberWithNotify = ->
  $.plumber errorHandler: (error) ->
    if not isProduction()
      $.notify.onError('<%= error.message %>') error
    @emit 'end'

# 確認用サーバ起動
gulp.task 'server', ->
  browserSync
    server:
      baseDir: dirs.dist

# ファイル監視とライブリロード
gulp.task 'watch', ->
  gulp.watch paths.md, ['md', 'jade', browserSync.reload]
  gulp.watch paths.jade, ['jade', browserSync.reload]
  gulp.watch paths.browserify, ['js', browserSync.reload]
  gulp.watch paths.sass, ['sass', browserSync.reload]
  gulp.watch paths.image, ['image', browserSync.reload]


###
# Task
###

# ビルドディレクトリのcleaning
gulp.task 'clean', del.bind null, ["#{dirs.dist}", "#{dirs.src}/templates/contents/"]

# デフォルトタスク (確認サーバ起動とファイル監視)
gulp.task 'default', ['server', 'watch']

# 本番用ファイル生成タスク
gulp.task 'build', ->
  env = 'production'
  runSequence 'clean', 'prodMd', 'prodJade', ['prodJS', 'prodCSS', 'image']
