$ = require 'jquery'

module.exports = class Modal

  constructor: ->
    @$modal = $('.Modal')
    @$wrapper = $('.Wrapper')
    $('.modalOpenBtn').on 'click', @onClickOpenBtn

    $('.modalConfirmBtn').on 'click', @onClickConfirmBtn
    $('.modalCancelBtn').on 'click', @onClickCancelBtn
    $('.modalCloseBtn').on 'click', @onClickCloseBtn

  onClickOpenBtn: =>
    @open()

  onClickConfirmBtn: =>
    @close()

  onClickCancelBtn: =>
    @close()

  onClickCloseBtn: =>
    @close()

  open: =>
    @$modal.addClass 'isActive'
    @scrollTop = $(window).scrollTop()
    @$wrapper.css
      position: "fixed"
      top: -1 * @scrollTop

  close: =>
    @$modal.removeClass 'isActive'
    @$wrapper.attr style:''
    $('html').prop scrollTop: @scrollTop
    $('body').prop scrollTop: @scrollTop
