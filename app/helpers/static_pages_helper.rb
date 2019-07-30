module StaticPagesHelper

  def ordem_services_in_series data
    label = [0 => "ABERTO", 8 => "AGUARDANDO_EMBARQUE", 9 => "EMBARCADO", 1 => "ENTREGA_EFETUADA", 2 => "FECHADO"]

    series = {}
    #data.each do |key, item|
      #series.push({name: label[key], data: item })

      # series[] = {name: label[key], data: {label[key] => item }}
    #end;
    series
  end
end
