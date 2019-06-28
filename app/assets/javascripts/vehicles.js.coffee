
$ ->
  $("#place").keyup ->
    place = $(this).val()
    length = place.length
    if length >= 8
      get_place place



get_place = (place) ->
  $.ajax
    url: "/vehicles/get_by_place"
    method: "GET"
    data: {place: place}
    dataType: "html"
    success: (data) ->
      $("#vehicle_place_result").html(data)
