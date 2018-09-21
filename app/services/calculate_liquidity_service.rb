class CalculateLiquidityService
  TON = 1000.00

  def initialize(params = {})
    @value_nf = params[:value_nf].to_f
    @weight = params[:weight].to_f
    @value_ton = params[:value_ton].to_f
    @type_charge = params[:type_charge_id]
    @eixos = params[:eixos]
    @daily_rate = params[:daily_rate]
    @risk_manager = params[:risk_manager]
    @toll = params[:toll]
    @lucre = params[:lucre]
    @stretch = StretchRoute.find(params[:trecho_id])
    @insurer = Insurer.find(params[:insurer_id])

    @add_icms_value_frete = params[:add_icms_value_frete]
    @quantity_cars = params[:quantity_cars]
  end

  def call
    freight = TableFreightService.new(@stretch, @type_charge, @eixos).call[:freight]
    discharge = calc_discharge(@weight, @value_ton)
    value_per_kg = (@value_ton.to_f / TON)
    secure = TableInsuranceService.new(@insurer, @stretch, @value_nf).call[:secure]

    total_cost = freight.to_f + @daily_rate.to_f + discharge.to_f + secure.to_f + @risk_manager.to_f + @toll.to_f
    
    lucre_percet = @lucre.to_f
    lucre = calc_lucre(total_cost, lucre_percet) 
    
    total_operation = total_cost.to_f + lucre.to_f

    icms = TableIcmsService.new(@stretch, total_operation.to_f).call[:icms]

    pis_cofins = calc_pis_cofins(total_operation.to_f, 7.00)

    if @add_icms_value_frete == ClientTablePrice::AddIcmsValueFete::SIM
      icms_value_frete_name = "Incide no valor do frete" 
      total_freight = total_operation.to_f + icms.to_f + pis_cofins.to_f
    elsif @add_icms_value_frete == ClientTablePrice::AddIcmsValueFete::NAO
      icms_value_frete_name = "Não incide no valor do frete" 
      total_freight = total_operation.to_f + pis_cofins.to_f
    else #verificar processe que ClientTabelPrice::AddIcmsValueFete::OBEDECE_CLIENTE
      icms_value_frete_name = "Não incide no valor do frete" 
      total_freight = total_operation.to_f + pis_cofins.to_f
    end

    quantity_cars = (@quantity_cars.to_i < 1) ? 1 : @quantity_cars

    return {
             value_nf: @value_nf,
               weight: @weight,
              freight: freight,
           daily_rate: @daily_rate,
            discharge: discharge,
               secure: secure,
         risk_manager: @risk_manager,
             value_kg: value_per_kg,
                 toll: @toll,
 add_icms_value_frete: icms_value_frete_name,
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

end