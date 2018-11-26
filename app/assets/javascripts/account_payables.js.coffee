$ ->
  $(document).on 'change', '#accountPayableTypeSelect', (evt) ->
    $.ajax
      url: '/type_account_select'
      dataType:"script"
      data: {
        type_id: $("#accountPayableTypeSelect option:selected").val()
      }

    return
  return

$ ->
  $(document).on 'change', '#accountPayableCostCenter', (evt) ->
    $.ajax
      url: '/sub_centro_custo_by_custo'
      dataType:"script"
      data: {
        cost_center_id: $("#accountPayableCostCenter option:selected").val()
      }

    return
  return

$ ->
  $(document).on 'change', '#accountPayableSubCostCenter', (evt) ->
    $.ajax
      url: '/sub_centro_custo_three_by_custo'
      dataType:"script"
      data: {
        cost_center_id: $("#accountPayableCostCenter option:selected").val()
        sub_cost_center_id: $("#accountPayableSubCostCenter option:selected").val()
      }

    return
  return
