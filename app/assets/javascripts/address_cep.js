$(function(){
   $(".auto_cep").change(function(){
     var cep     = $(this).val().replace(/[^0-9]/, '');
     var boxes   = $("#boxCampos");
     var msgErro = $("#mensagemErro");
     console.log('CEP: ' + cep)
     boxes.addClass('ocultar');
     msgErro.addClass('ocultar');

    if(cep !== ""){
        $.getJSON('/get_address_by_cep?cep=' + cep, function(data){
           console.log(data)
           $(".auto_endereco").val(data.logradouro);
           $(".auto_bairro").val(data.bairro);
           $(".auto_cidade").val(data.localidade);
           $(".auto_estado").val(data.uf);
           $(".auto_numero").focus();
           boxes.removeClass('ocultar');
          }).fail(function(){
            //Não retornando um valor válido, ele mostra a mensagem
          msgErro.removeClass('ocultar').html('CEP inexistente')
       });
       }
   });
});
