class DataEdiNotfisEntregaToSector < ActiveRecord::Migration[5.1]
  def data
    Sector.create!(name:'EDI_NOTFIS_ENTREGA');
  end
end
