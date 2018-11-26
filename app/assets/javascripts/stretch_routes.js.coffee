$ ->
  $(document).on 'focusin', '#accountPayableTypeSelect', (evt) ->
    $.ajax
      #url: '/get_stretch_routes_from_client_cnpj'
      dataType:"script"
      data: {
        cpf_cnpj: $("#billing_cpf_cpnj").val()

      }

    return
  return

$ ->
  $(document).on 'change', '#routesSelect', (evt) ->
    $.ajax
      #url: '/get_client_table_price_of_by_client_cnpj_and_stretch_route'
      dataType:"script"
      data: {
        cpf_cnpj: $("#billing_cpf_cpnj").val()
        stretch_route_id: $("#routesSelect option:selected").val()
      }

    return
  return
