$(document).ready(function(e) {
   $('#ordem_service_type_service, #ordem_service_nfe').nestedFields();
});

$(document).ready(function(e) {
  $(".placa").mask("aaa-9999");
  $(".data").mask("99-99-9999", {placeholder:"dd/mm/yyyy"});
//$(".phone").mask("(999) 999-9999");  
});

