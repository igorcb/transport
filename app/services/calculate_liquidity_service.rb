class CalculateLiquidityService
  TON = 1000.00

  def initialize(params = {})
    @valor_nota_fiscal = params["value_invoice"].first.to_f
    @weight = params["weight"].first.to_f
    @value_ton = params["value_ton"].first.to_f
    @type_charge = params["type_charge_id"]
    @eixos = params["qtde_eixos"].first.to_i
    @daily_rate = params["daily_rate"].first.to_f
    @risk_manager = params["risk_manager"].first.to_f
    @toll = params["toll"].first.to_f
    @lucre = params["lucre"].first.to_f
    @stretch = StretchRoute.find(params["trecho_id"])
    @insurer = Insurer.find(params["insurer_id"])

    @add_icms_value_frete = params["add_icms_value_frete"].to_i
    @quantity_cars = params["quantity_cars"].first.to_i
    @number_days = params["number_days"].first.to_i
    @perc_advance = params["perc_advance"].first.to_f
  end

  def call
    freight = TableFreightService.new(@stretch, @type_charge, @eixos).call[:freight]
    discharge = calc_discharge(@weight, @value_ton)
    value_per_kg = (@value_ton.to_f / TON)
    secure = TableInsuranceService.new(@insurer, @stretch, @valor_nota_fiscal).call[:secure]

    total_cost = freight.to_f + @daily_rate.to_f + discharge.to_f + secure.to_f + @risk_manager.to_f + @toll.to_f
    
    lucre_percet = @lucre.to_f
    lucre = calc_lucre(total_cost, lucre_percet) 
    
    
    total_operation = total_cost.to_f + lucre.to_f

    icms = TableIcmsService.new(@stretch, total_operation.to_f).call[:icms]

    pis_cofins = calc_pis_cofins(total_operation.to_f, 7.00)

    if @add_icms_value_frete == ClientTablePrice::AddIcmsValueFete::SIM
      icms_value_frete_name = "Incide no valor do frete" 
      total_freight = total_operation.to_f + icms.to_f + pis_cofins.to_f
      value_to_advance = total_cost + icms.to_f + pis_cofins.to_f
    elsif @add_icms_value_frete == ClientTablePrice::AddIcmsValueFete::NAO
      icms_value_frete_name = "Não incide no valor do frete" 
      total_freight = total_operation.to_f + pis_cofins.to_f
      value_to_advance = total_cost + pis_cofins.to_f
    else #verificar processe que ClientTabelPrice::AddIcmsValueFete::OBEDECE_CLIENTE
      icms_value_frete_name = "Não incide no valor do frete" 
      total_freight = total_operation.to_f + pis_cofins.to_f
      value_to_advance = total_cost + pis_cofins.to_f
    end

    quantity_cars = (@quantity_cars.to_i < 1) ? 1 : @quantity_cars
    
    @advance = calc_advance(value_to_advance, @perc_advance, @number_days)

    return {
             value_nf: @valor_nota_fiscal,
               weight: @weight,
              freight: freight,
           daily_rate: @daily_rate,
            discharge: discharge,
               secure: secure,
         risk_manager: @risk_manager,
             value_kg: value_per_kg,
                 toll: @toll,
 add_icms_value_frete: icms_value_frete_name,
          number_days: @number_days,
         perc_advance: @perc_advance,
              advance: @advance,
        quantity_cars: quantity_cars,
           total_cost: total_cost,
                lucre: lucre,
      total_operation: total_operation,
           total_icms: icms,
     total_pis_cofins: pis_cofins,
        total_freight: total_freight
           }
  end

  private
    def calc_discharge(weight, value_ton)
      value = BigDecimal.new(0)
      value = (value_ton / TON) * weight
      value
    end

    def calc_lucre(value, percent)
      value = (value * percent) / 100
      value
    end

    def calc_pis_cofins(value, percent)
      perc = 1 - ( percent / 100) 
      value_calc = ((value) / perc) - (value) 
      value_calc
    end

    def calc_advance(value, percent, days)
      #byebug
      value_day = ((value * percent) / 100 ) / 30
      puts "Value Day: #{value_day}"
      value_total = value + (value_day * days)
      value_total
    end

end