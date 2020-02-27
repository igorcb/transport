# json.warehouse @warehouse
if params[:deposit].present?
  json.occupied_percent @occupied_percent
  json.warehouse @warehouse, :id, :name, :address, :number, :district, :city, :state, :zip_code
  json.deposit @deposit, :id, :name
  json.streets @street do |s|
    json.id s.id
    json.name s.name

    # get floors
    json.floors s.floors do |f|
      json.id f.id
      json.name f.name

      # get houses
      json.houses f.houses.order(:id).active do |h|
        json.id h.id
        json.name h.name
        json.occupied h.occupied
        json.address "#{s.name} - #{f.name} - #{h.name}"        
        json.pallet_number h.palletizing_pallet.present? ? h.palletizing_pallet.number : "" 
      end
    end
  end
else
  json.errors "Nenhum parametro foi encontrado"

end
