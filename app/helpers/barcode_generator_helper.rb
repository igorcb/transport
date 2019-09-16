module BarcodeGeneratorHelper
  require 'barby'
  require 'barby/barcode/code_128'
  require 'barby/outputter/png_outputter'
  require 'barby/outputter/html_outputter'

  def code128 number, variable=nil
    barcode = Barby::Code128.new(number)
    if (variable.nil?)
      return barcode.to_image().to_data_url
    else
      return barcode.to_image(variable).to_data_url
    end

  end

end
