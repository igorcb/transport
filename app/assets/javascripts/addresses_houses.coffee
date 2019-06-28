# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  # console.log("DOM is ready")
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
    $(".btn-see").show()

  # click see button
  $(document).on 'click', '.btn-see', ->
    param = $("#deposit-select").val()
    get_houses(param)
    $("body").css("overflow", "hidden").add("html").scrollTop(0)
    $("#content-house").show(800)
    false

  # click close
  $("#content-house .close").on "click", ->
    $("body").css("overflow", "")
    $("#content-house").hide(800)

  # Toggle do occupe / do vacate
  $(document).on 'click', '.houses', ->
    house_id = $(this).attr("data-house-id")
    occupied = $(this).hasClass("occupied")
    $(this).addClass("load")
    toggle_occupied house_id, occupied


  setInterval ( =>
    param = $("#deposit-select").val()
    if param != null and param != ""
      get_houses(param)
  ), 10000


# functions
get_houses = (param) ->
  $.ajax
    url: "/addresses_houses/houses.json"
    method: "GET"
    data: {deposit: param}
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
            html += "<div class='houses #{if h.occupied == "occuped" then " occupied" }' title='#{h.id}' data-house-id='#{h.id}'>#{h.address}</div>"
          html += "</div>"

      $('#view-houses').html(html)


toggle_occupied = (param, occupied) ->
  $.ajax
    url: if occupied then "/addresses_houses/do_vacate" else "/addresses_houses/do_occupe"
    method: "GET"
    data: {house_id: param}
    dataType: "html"
    success: (data) ->
      param = $("#deposit-select").val()
      get_houses(param)
    # success: (data) ->
