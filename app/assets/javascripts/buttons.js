$(document).ready(function(){
   btn_one_click()
   submit_one_click()
})


function btn_one_click() {
  $("a.btn-one-click, a[data-one-click=true]").click(function(){
    href = $(this).attr("href")
    $(this).attr("href", "#").prop("disabled", true)
    window.location.href = href
    return false
  })
}

function submit_one_click() {
  $(".submit-one-click").click(function(){
    $(this).prop("disabled", true)
  })
}
