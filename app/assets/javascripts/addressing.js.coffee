
$ ->
  $("#initStreet").on "keyup change", ->
    initStreet = parseInt( $(this).val() )
    $("#endStreet").val( initStreet )

  $("#endStreet").on "keyup change", ->
    endStreet = parseInt( $(this).val() )
    initStreet = parseInt( $("#initStreet").val() )
    if endStreet < initStreet
      $("#endStreet").val( initStreet )
