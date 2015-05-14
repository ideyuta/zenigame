'use strict'

$ = require 'jquery'
DropDownMenu = require './dropdownMenu.coffee'


$ ->
  $('.DropDownMenu').each -> new DropDownMenu @

  return
