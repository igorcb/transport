json.array!(@promoters) do |promoter|
  json.extract! promoter, :id, :cpf, :nome, :fantasia, :endereco, :numero, :complemento, :bairro, :cidade, :estado, :cep
  json.url promoter_url(promoter, format: :json)
end
