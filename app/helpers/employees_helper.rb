module EmployeesHelper
  def select_tipo_employee
    ([["FIXO","0"],["DIARISTA","1"]])
  end

  def select_escolaridade_employee
    ([['Fundamental incompleto', '0'], ['Fundamental completo', '1'], ['Médio incompleto', '2'], ['Médio completo', '3'], ['Superior incompleto', '4'], ['Superior cursando', '5'], ['Superior completo', '6']])
  end

  def show_line_build field, name, label_size=3
    html = <<-HTML
    <div class='row'>
      <div class='col-md-#{label_size}'><strong> #{name} :</strong></div>
      <div class='col-md-8'> #{field} </div>
    </div>
    HTML
    html.html_safe;
  end
end
