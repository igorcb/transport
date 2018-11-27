#encoding: utf-8
class AddressController < ApplicationController
	#require 'json/objects'
	require 'correios-cep'
  def get_address_by_cep
    #puts ">>>>>>>>>>>>> localizando cep: #{params[:cep]}"
    retorno = 1
    begin
      #data = Cep.new.cep(params[:cep])
      address = Correios::CEP::AddressFinder.get(params[:cep])
      data = {logradouro: address[:address], bairro: address[:neighborhood], localidade: address[:city], uf: address[:state], cep: address[:zipcode]}
    rescue
      retorno = 0
    ensure
      #puts ">>>>>>>>> Endereco: #{data.to_json.force_encoding("UTF-8")}"
			#@stretch_routes = stretchs.map {|c| [c.stretch_source_and_target_long, c.id] }.insert(0, 'SELECIONE O TRECHO')
			puts ">>>>>>>>>>>>>>>> Return: #{@data}"
			@data = data.nil? ? nil : data.to_json.force_encoding("UTF-8")
      #render :text => data
    end
  end

  def get_city_by_uf
    uf = params[:uf]
    cities = City.where(uf: uf)
    city_array = []
    cities.each do |s|
      city_array << {:id => s.name, :n => s.name}
    end
    #puts ">>>>>>>>>>>>>> #{city_array.to_json}"
    render :text => city_array.to_json.force_encoding("UTF-8")
  end
end
