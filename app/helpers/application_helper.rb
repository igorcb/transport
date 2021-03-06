module ApplicationHelper
  #
  def full_title(page_title)
    company = Company.first
    base_title = company.razao_social
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def fantasy_title(page_title)
    if signed_in?
      company = Company.first
      base_title = company.fantasia
      if page_title.empty?
        # base_title
        "#{base_title} | #{page_title} - YOHAN"
      else
        "#{base_title} | #{page_title} - YOHAN"
      end
    else
      "YOHAN - Sistema WMS"
    end
  end

  def select_uf
    ([["AC","AC"],["AL","AL"],["AM","AM"],["AP","AP"],["BA","BA"],["CE","CE"],["DF","DF"],["ES","ES"],
    ["GO","GO"],["MA","MA"],["MG","MG"],["MS","MS"],["MT","MT"],["PA","PA"],["PB","PB"],["PE","PE"],["PI","PI"],["PR","PR"],
    ["RJ","RJ"],["RN","RN"],["RO","RO"],["RR","RR"],["RS","RS"],["SC","SC"],["SE","SE"],["SP","SP"],["TO","TO"]])
  end

  def select_sim_nao
    ([['Não', false], ['Sim', true]])
  end

  def select_unidade_medida
    ([['UN', 'UN'], ['CX', 'CX'],['LT', 'LT']])
  end

  def extenso_boolean(params)
    #params = params.nil? ? false : false
    case params
      when nil   then "Não"
      when false then "Não"
      when true  then "Sim"
    end
  end

  def extenso_integer(params)
    #params = params.nil? ? false : false
    case params
    when 0 then "Não"
    when 1 then "Sim"
    end
  end

  def date_br(date)
    # formatting date: dd-mm-yyyy
    #date.nil? ? "" : date.strftime("%d-%m-%Y")
    #l @bolsista.data, format: '%d/%m/%Y'
    date.nil? ? "" : I18n.l(date, format: '%d/%m/%Y')
  end

  def time_br(date)
    date.nil? ? "" : I18n.l(date, format: '%H:%M')
  end

  def date_hora_br(date)
    date.nil? ? "" : I18n.l(date, format: '%d/%m/%Y %H:%M:%S')
  end

  def extract_year(date)
    date.nil? ? "" : I18n.l(date, format: '%Y')
  end

  def select_tipo_operacao
    ([['Conta Corrente', 0], ['Conta Poupança', 1],["Conta Salário", 2]])
  end

  def to_real(number)
     number_to_currency(number, :separator => ",", :delimiter => ".")
  end

  def to_decimal(decimal)
     number_to_currency(decimal, :separator => ",", :delimiter => ".", :precision => 3 )
  end

  def select_credito_debito
    ([['Crédito', 1], ['Débito', -1]])
  end

  def select_status_ordem_service_type_services
    ([["ABERTO", 0],["PENDENTE", 1], ["PAGO", 2]])
  end

  def type_account_supplier
    ([["Fornecedor", 1],["Motorista", 2], ["Cliente", 3], ["Funcionario", 4],
      ["Transportadora", 5]])
  end

  def city_of_state(uf)
    City.where(uf: uf)
  end

  def liquidity_include?(value)
    value.to_f > 0.00 ? 'SIM INCLUSO' : 'NÃO INCLUSO'
  end
end
