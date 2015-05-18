'use strict'

$ = require 'jquery'
DropDownMenu = require './dropdownMenu.coffee'
Modal = require './modal.coffee'


$ ->
  $('.DropDownMenu').each -> new DropDownMenu @
  zn.modal = new Modal

  return
