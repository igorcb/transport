class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.integer :code_uf
      t.string :name
      t.string :uf, limit: 2
      t.references :region, index: true

      t.timestamps
    end
  end

  def data
		State.create!(code_uf: 12, name: 'Acre', uf: "AC", region_id: 1)
		State.create!(code_uf: 27, name: 'Alagoas', uf: "AL", region_id: 2)
		State.create!(code_uf: 16, name: 'Amapá', uf: "AP", region_id: 1)
		State.create!(code_uf: 13, name: 'Amazonas', uf: "AM", region_id: 1)
		State.create!(code_uf: 29, name: 'Bahia', uf: 'BA', region_id: 2)
		State.create!(code_uf: 23, name: 'Ceará', uf: 'CE', region_id: 2)
		State.create!(code_uf: 53, name: 'Distrito Federal', uf: 'DF', region_id: 5)
		State.create!(code_uf: 32, name: 'Espírito Santo', uf: 'ES', region_id: 3)
		State.create!(code_uf: 52, name: 'Goiás', uf: 'GO', region_id: 5)
		State.create!(code_uf: 21, name: 'Maranhão', uf: 'MA', region_id: 2)
		State.create!(code_uf: 51, name: 'Mato Grosso', uf: 'MT' , region_id: 5)
		State.create!(code_uf: 50, name: 'Mato Grosso do Sul', uf: 'MS', region_id: 5)
		State.create!(code_uf: 31, name: 'Minas Gerais', uf: 'MG', region_id: 3)
		State.create!(code_uf: 15, name: 'Pará', uf: 'PA', region_id: 1)
		State.create!(code_uf: 25, name: 'Paraíba', uf: 'PB', region_id: 2)
		State.create!(code_uf: 41, name: 'Paraná', uf: 'PR' , region_id: 4)
		State.create!(code_uf: 26, name: 'Pernambuco', uf: 'PE', region_id: 2);
		State.create!(code_uf: 22, name: 'Piauí', uf: 'PI', region_id: 2);
		State.create!(code_uf: 33, name: 'Rio de Janeiro', uf: 'RJ', region_id: 3);
		State.create!(code_uf: 24, name: 'Rio Grande do Norte', uf: 'RN', region_id: 2);
		State.create!(code_uf: 43, name: 'Rio Grande do Sul', uf: 'RS', region_id: 4);
		State.create!(code_uf: 11, name: 'Rondônia', uf: 'RO', region_id: 1);
		State.create!(code_uf: 14, name: 'Roraima', uf: 'RR', region_id: 1);
		State.create!(code_uf: 42, name: 'Santa Catarina', uf: 'SC', region_id: 4);
		State.create!(code_uf: 35, name: 'São Paulo', uf: 'SP', region_id: 3);
		State.create!(code_uf: 28, name: 'Sergipe', uf: 'SE', region_id: 2);
		State.create!(code_uf: 17, name: 'Tocantins', uf: 'TO', region_id: 1);  
	end

end
