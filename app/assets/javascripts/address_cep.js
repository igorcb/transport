$(function(){

  if ($(".auto_cep").hasClass()) {

    if($(".auto_cep").val().length == 9 ){

      $(".auto_endereco, .auto_bairro, .auto_cidade, .auto_estado").prop("disabled", true)
    }
    $(".auto_cep").keyup(function(){
      var cep     = $(this).val().replace(/[^0-9]/, '');
      var boxes   = $("#boxCampos");
      var msgErro = $("#mensagemErro");
      console.log('CEP: ' + cep)
      boxes.addClass('ocultar');
      msgErro.addClass('ocultar');

      if(cep.length >= 8){
        $.getJSON('/get_address_by_cep?cep=' + cep, function(data){
          console.log(data)
          $(".auto_endereco").val(data.logradouro);
          $(".auto_bairro").val(data.bairro);
          $(".auto_cidade").val(data.localidade);
          $(".auto_estado").val(data.uf);
          $(".auto_numero").focus();
          $(".auto_endereco, .auto_bairro, .auto_cidade, .auto_estado").prop("disabled", false)
          boxes.removeClass('ocultar');
        }).fail(function(){
          //Não retornando um valor válido, ele mostra a mensagem
          msgErro.removeClass('ocultar').html('CEP inexistente')
        });
      } else {
        $(".auto_endereco, .auto_bairro, .auto_cidade, .auto_estado").prop("disabled", true)
      }
    });
  }
});
