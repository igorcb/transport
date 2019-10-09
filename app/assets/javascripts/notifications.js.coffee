class Notifications
  constructor: ->
    @notifications = $("[data-behavior='notifications']")
    @setup() if @notifications.length > 0

  setup: ->
    $(document).on "click", "[data-behavior='notifications-link']", () ->
      href = $(this).attr("data-href")
      $.ajax(
        url: href
        dataType: "JSON"
        method: "GET"
        success: ->
          $("[data-behavior='unread-count']").text(0)
          # $(".show-notification").hide()
          new Notifications
      )

    $.ajax(
      url: "/notifications.json"
      dataType: "JSON"
      method: "GET"
      success: @handleSuccess
    )

  # handleClick: (e) =>





  handleSuccess: (data) =>
    # console.log(data['notification'])
    items = $.map data['notification'], (notification) ->
      "<li> <a class='dropdown-item' data-behavior='notifications-link' href='#{notification.url}' data-href='/notifications/#{notification.id}/mark_as_read'>#{notification.name} #{notification.action}</a>"

    $("[data-behavior='unread-count']").text(items.length)
    $("[data-behavior='notification-items']").html(items)
    # if items.length > 0
    #   $(".show-notification").show()

jQuery ->
  new Notifications


  # 
  # setInterval ( =>
  #   new Notifications
  # ), 10000
