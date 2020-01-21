$ ->
  $(document).on 'change', '#controlPalletTypeResponsible', (evt) ->
    $.ajax
      url: '/type_responsible_select'
      dataType:"script"
      data: {
        type_id: $("#controlPalletTypeResponsible option:selected").val()
      }

    return
  return
