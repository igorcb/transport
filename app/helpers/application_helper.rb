module ApplicationHelper
  def full_title(page_title)
    base_title = "Transport"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
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
    case params 
      when false then "Não"
      when true  then "Sim"
    end
  end

  def date_br(date)
    # formatting date: dd-mm-yyyy
    date.strftime("%d-%m%Y")
  end

end
