# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  console.log("DOM is ready")
  ###
  Select warehouse
  Load deposit
  ###
  $("#warehouse-select").change ->
    param = "warehouse="+$(this).val();
    # console.log(param);
    $.getJSON('/deposits/get_deposits_by_warehouse', param, (data) ->
      options = '<option value="">Selecione um galpão</option>'

      $.each data, (i, item) =>
        options += '<option value="' + item.id + '">' + item.n + '</option>'

      # console.log(options);
      $("#street-select").html("").prop("disabled", true)
      $("#deposit-select").html(options).prop("disabled", false)
    )


  ###
  Select deposit
  Load houses
  ###
  $(document).on 'change', '#deposit-select', ->
    param = "deposit="+$(this).val();
    get_houses(param)

  setInterval ( =>
    param = $("#deposit-select").val();
    if param != null and param != ""
      get_houses("deposit="+param)
  ), 10000


# functions
get_houses = (param) ->
  $.ajax
    url: "/addresses_houses/houses.json?"+param
    dataType: "text"
    success: (data) ->
      d =  JSON.parse data

      html = "<h1>Armazém #{d.warehouse.name}</h1>"
      html += "<h2>Galpão #{d.deposit.name}</h2>"

      html += "<div class='bar'><div class='progress' style='width:#{d.occupied_percent}%'>#{d.occupied_percent}%</div></div>"

      $.each d.streets, (key, s) ->
        html += "<h3>street #{s.name}</h3>"
        $.each s.floors, (key, f) ->
          html += "<div class='floors'><div class='houses'>#{f.name} stage</div>"
          $.each f.houses, (key, h) ->
            html += "<div class='houses #{if h.occupied == "occuped" then " occupied" }' title='#{h.id}'>#{h.address}</div>"
          html += "</div>"

      $('#view-houses').html(html)
