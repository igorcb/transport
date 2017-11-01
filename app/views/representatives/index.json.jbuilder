json.array!(@representatives) do |representative|
  json.extract! representative, :id, :tipo_pessoa, :cpf_cnpj, :nome, :fantasia, :inscricao_estadual, :inscricao_municipal, :endereco, :numero, :complemento, :bairro, :cidade, :estado, :rg, :orgao_emissor, :data_emissao, :observacao
  json.url representative_url(representative, format: :json)
end
