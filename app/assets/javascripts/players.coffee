# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
        $('#players').dataTable({
        pagingType: 'full_numbers', 
        order: [[ 3, "asc" ],[ 0, "asc" ],[ 1, "asc" ]]         
        }) 