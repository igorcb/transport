$(document).ready(function(){
   btn_one_click()
   submit_one_click()
})


function btn_one_click() {
  $(".btn-one-click").click(function(){
    href = $(this).attr("href")
    $(this).attr("href", "#")
    window.location.href = href
  })
}

function submit_one_click() {
  $(".submit-one-click").click(function(){
    $(this).prop("disabled", true)
  })
}
