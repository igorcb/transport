module BootstrapHelper
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
