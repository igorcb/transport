module EmployeesHelper
  def select_tipo_employee
    ([["FIXO","0"],["DIARISTA","1"]])
  end

  def select_escolaridade_employee
    ([['Fundamental incompleto', '0'], ['fundamental completo', '1'], ['Médio incompleto', '2'], ['Médio completo', '3'], ['Superior incompleto', '4'], ['Superior cursando', '5'], ['Superior completo', '6']])
  end
end
