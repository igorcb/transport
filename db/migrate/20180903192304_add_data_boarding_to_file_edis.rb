class AddDataBoardingToFileEdis < ActiveRecord::Migration[5.0]
  def change
    add_column :file_edis, :date_boarding, :date
    add_reference :file_edis, :shipper, index: true
    add_reference :file_edis, :carrier, index: true
    add_column :file_edis, :place, :string
    add_column :file_edis, :weight, :decimal, precision: 10, scale: 3
    add_column :file_edis, :volume, :decimal, precision: 10, scale: 3
    add_column :file_edis, :value_total, :decimal, precision: 20, scale: 4
    add_column :file_edis, :qtde, :integer
  end
end
