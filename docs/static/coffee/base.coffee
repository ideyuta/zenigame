'use strict'

$ = require 'jquery'
ImagesLoaded = require 'imagesloaded'

class Tweet

  constructor: ->
    # 変数定義
    @$twCount = $('.twCount')
    # イベント定義
    @$twCount.each (index, elm) =>
      url = elm.attr('href')
      count(elm, url)

  count: (elm, url) ->
    if elm
      pageURL = url ? url : location.url
      pageURL = encodeURI pageURL
      url = 'http://urls.api.twitter.com/1/urls/count.json?url=' + pageURL
      $.ajax
        url: url,
        dataType: 'jsonp',
        success: (json) ->
          $(elm).html json.count

$ ->
  zn.tweet = new Tweet

  return
