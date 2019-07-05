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

  def form_group size={}, attr={}, &block
    clas = ""
    screen = {smaller: "xs", small: "sm", medium: "md", large: "lg", larger: "xg"}
    size.each { |k, s|
      clas += "col-#{screen[k]}-#{s} "
    }
    html = <<-HTML
    <div id='#{attr[:id]}' class='form-group #{clas} #{attr[:class]}'>
      #{capture(&block)}
    </div>
    HTML
    html.html_safe if block_given?
  end

  def input_class
    return "form-control"
  end

  def row attr={}, &block
    html = <<-HTML
    <div id='#{attr[:id]}' class='row #{attr[:class]}'>
      #{capture(&block)}
    </div>
    HTML
    html.html_safe if block_given?
  end

end
