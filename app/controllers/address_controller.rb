#encoding: utf-8
class AddressController < ApplicationController
	require 'json/objects'
	
  def get_address_by_cep
    puts ">>>>>>>>>>>>> localizando cep: #{params[:cep]}"
    retorno = 1
    begin
      data = Cep.new.cep(params[:cep])
    rescue
      retorno = 0
    ensure
      puts ">>>>>>>>> Endereco: #{data.to_json}"
      data = data.nil? ? nil : data.to_json
      render :text => data
    end
  end

  def get_city_by_uf
    uf = params[:uf]
    cities = City.where(uf: uf)
    city_array = []
    cities.each do |s|
      city_array << {:id => s.name, :n => s.name}
    end
    puts ">>>>>>>>>>>>>> #{city_array.to_json}"
    render :text => city_array.to_json
  end
end
