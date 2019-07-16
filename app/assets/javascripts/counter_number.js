
$(document).ready(function() {
  // elem = $(".counter_number")
  // animateNumber()
});

  function animateNumber(elem){
    var init = elem.attr("data-init")
    var el = elem
    var end = elem.attr("data-end")

    if (end >= init) {
      var dif = end-init
      var speed = (dif < 50) ? 60 : 0.1;
      console.log(speed);
      var loop =  setInterval( function(){
            el.html(init)
            if (init >= end) {
              clearInterval(loop);
            }
            init++
        }, speed);

    }
  }
