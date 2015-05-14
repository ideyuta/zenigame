$ = require 'jquery'

module.exports = class DropDownMenu

  constructor: (el) ->
    @$el = $(el)
    @$btn = @$el.find('.btn')
    @$itemList = @$el.find '.itemList'
    @$item = @$el.find '.item'

    @$btn.on 'click', (e) =>
      @$itemList.toggleClass 'isHidden'
      e.stopPropagation()

    $(window).on 'click', =>
      if not @$itemList.hasClass 'isHidden'
        @$itemList.addClass 'isHidden'

    @$item.each (idx, el) =>
      $(el).on 'click', @onClickItem

  onClickItem: (e) =>
    e.returnValue = false
    if e.preventDefault
      e.preventDefault()
    $el = $(e.target)
    @$item.removeClass 'isActive'
    $el.addClass 'isActive'
    @$btn.find('.value').html $el.text()
    @$itemList.toggleClass 'isHidden'

