class CalculateLiquidityService
 
  def initialize(params = {})
    @value_nf = params[:value_nf].to_f
    @weight = params[:weight].to_f
    @value_ton = params[:value_ton].to_f
    @type_charge = params[:type_charge_id]
    @eixos = params[:eixos]
    @daily_rate = params[:daily_rate]
    @risk_manager = params[:risk_manager]
    @toll = params[:toll]
    @stretch = StretchRoute.find(params[:trecho_id])
    @insurer = Insurer.find(params[:insurer_id])
  end

  def call
    freight = TableFreightService.new(@stretch, @type_charge, @eixos).call[:freight]
    discharge = calc_discharge(@weight, @value_ton)
    secure = TableInsuranceService.new(@insurer, @stretch, @value_nf).call[:secure]

    total_cost = freight + @daily_rate + discharge + secure + @risk_manager + @toll
    
    lucre_percet = 18.00 # @stretch.lucre_percet
    lucre = calc_lucre(total_cost, lucre_percet) 
    
    total_operation = total_cost + lucre

    icms = TableIcmsService.new(@stretch, total_operation).call[:icms]

    pis_cofins = calc_pis_cofins(total_operation, 7.00)

    total_freight = total_operation + icms + pis_cofins

    return {
           value_nf: @value_nf,
             weight: @weight,
            freight: freight,
         daily_rate: @daily_rate,
          discharge: discharge,
             secure: secure,
       risk_manager: @risk_manager,
               toll: @toll,
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
      value = (value_ton / 1000) * weight
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