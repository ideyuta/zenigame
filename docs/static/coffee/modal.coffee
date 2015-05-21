$ = require 'jquery'

module.exports = class Modal

  constructor: ->
    @$modal = $('.Modal')
    @$wrapper = $('.Wrapper')

    @$modal.find('.dialog').css display: 'none'
    @$modal.find('.page').css display: 'none'

    $('.modalOpenBtn').on 'click', @onClickOpenBtn
    $('.modalConfirmBtn').on 'click', @onClickConfirmBtn
    $('.modalCancelBtn').on 'click', @onClickCancelBtn
    $('.modalCloseBtn').on 'click', @onClickCloseBtn

  onClickOpenBtn: (e) =>
    @$target = $(".#{$(e.target).data('name')}")
    @$target.css display: 'block'
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
    @$target.css display: 'none'
    @$wrapper.attr style:''
    $('html').prop scrollTop: @scrollTop
    $('body').prop scrollTop: @scrollTop
