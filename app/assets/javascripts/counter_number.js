class CounterNumber {

  constructor(selector){
    this.elem = document.querySelector(selector)
    return this.animateNumber()
  }

  getInitNumber(){
    return this.elem.getAttribute("data-init")
  }

  getEndNumber(){
    return this.elem.getAttribute("data-end")
  }

  animateNumber(){
    var init = this.getInitNumber()
    var el = this.elem
    var end = this.getEndNumber()

    if (end >= init) {
    var dif = end-init
    var speed = (dif < 50) ? 60 : 0.1;
    console.log(speed);
    var loop =  setInterval( function(){
          el.innerHTML = init
          if (init >= end) {
            clearInterval(loop);
          }
          init++
      }, speed);

    }
  }



}
