require 'prawn/table'

class CalculateLiquidityPdf < Prawn::Document
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper
  def initialize(freight_minimum)
    super()
    @freight_minimum = freight_minimum
    header
    text_space
    table_header
    text_content
    table_value
    text_space
    table_footer
    text_content_footer
  end

  def header
    #This inserts an image in the pdf file and sets the size of the image
    #image "#{Rails.root}/app/assets/images/l7-logo.png", width: 128, height: 40
    company = Company.first

    y_position = cursor - 2
    bounding_box([0, y_position], :width => 240, :height => 50) do
      image company.image.path, width: 128, height: 40
    end
    bounding_box([250, y_position], :width => 290, :height => 50) do
      text company.cnpj, :size => 10, align: :right
      text company.razao_social, :size => 10, align: :right
      text company.endereco + ', ' + company.numero, :size => 10, align: :right
      text company.cidade_estado, :size => 10, align: :right
    end
  end

  def text_space
    # The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
    y_position = cursor - 20

    # The bounding_box takes the x and y coordinates for positioning its content and some options to style it
    bounding_box([0, y_position], :width => 540, :height => 10) do
      text ""
    end
  end

  def table_header
    table_content_header = [
     ["Tipo de Veiculo", @freight_minimum[:output].first[:type_vehicle]],
     ["Trecho", @freight_minimum[:output].first[:stretch_long]],
     ["Vr. NF-e", number_to_currency(@freight_minimum[:output].first[:value_nf], unit: "R$ ", separator: ",", delimiter: ".")],
     ["Peso Bruto", number_to_currency( @freight_minimum[:output].first[:weight], precision: 3, separator: ',', delimiter: '.')]
     ]

    table table_content_header, width: bounds.width do
      self.column_widths = [140, 400]
      self.cells[0,0].background_color = 'EEEEEE'
      self.cells[1,0].background_color = 'EEEEEE'
      self.cells[2,0].background_color = 'EEEEEE'
      self.cells[3,0].background_color = 'EEEEEE'
    end
  end

  def text_content
    # The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
    y_position = cursor - 20

    # The bounding_box takes the x and y coordinates for positioning its content and some options to style it
    bounding_box([0, y_position], :width => 540, :height => 30) do
      text "Essa proposta tem o valor conforme as informações recebida pelo solicitante, caso as informações tem divergencias o calculo será refeito.", :color => "ff0000", :size => 10
    end
  end

  def table_value
    table_content_value = [
     ["VALOR TOTAL DO FRETE", number_to_currency(@freight_minimum[:output].first[:total_freight], unit: "R$ ", separator: ",", delimiter: ".")],
     ["PRAZO PARA PAGAMENTO", TableFreight.payment_method(@freight_minimum[:output].first[:payment_method])]
     ]

    table table_content_value, width: bounds.width do
      self.row_colors = ['c0ded9']
      self.column_widths = [180, 360]
    end
  end

  def table_footer
    if @freight_minimum[:input][:add_icms_value_frete].to_i == ClientTablePrice::AddIcmsValueFete::SIM
      icms_text = 'SIM INCLUSO'
    else
      icms_text = 'NÃO INCLUSO'
    end

    table_content_footer = [
      ["PEDAGIO", liquidity_include?(@freight_minimum[:output].first[:toll])],
      ["DIARIA DO VEÍCULO", liquidity_include?(@freight_minimum[:output].first[:daily_rate])],
      ["CARGA", liquidity_include?(@freight_minimum[:output].first[:charge_value])],
      ["DESCARGA", liquidity_include?(@freight_minimum[:output].first[:discharge])],
      ["SEGURO", liquidity_include?(@freight_minimum[:output].first[:secure])],
      ["GR", liquidity_include?(@freight_minimum[:output].first[:risk_manager])],
      ["ICMS", icms_text],
      ]
    table table_content_footer, width: bounds.width do
      self.column_widths = [130, 410]
    end
  end

  def text_content_footer
    # The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
    y_position = cursor - 20

    # The bounding_box takes the x and y coordinates for positioning its content and some options to style it
    bounding_box([0, y_position], :width => 540, :height => 50) do
      #text "Listagem Grupo de Clientes #{cursor}", size: 15, style: :bold
      # move_cursor_to cursor + 10
      text "PROPOSTA COM VALIDADE DE 5 DIAS A CONTAR DA DATA DA SOLICITAÇÃO INFORMA ACIMA." , size: 10
      text "OBS:" , size: 10
      text "IMPRODUTIVIDADE: Free Time de 05hrs (cinco horas) PARA REALIZAÇÃO DA DESCARGA", size: 10
      text "APÓS O PRAZO COBRAMOS DIARIA DE R$ 500,00.", size: 10
    end

    # bounding_box([300, y_position], :width => 270, :height => 300) do
    #   text "Duis vel", size: 15, style: :bold
    #   text "Duis vel tortor elementum, ultrices tortor vel, accumsan dui. Nullam in dolor rutrum, gravida turpis eu, vestibulum lectus. Pellentesque aliquet dignissim justo ut fringilla. Interdum et malesuada fames ac ante ipsum primis in faucibus. Ut venenatis massa non eros venenatis aliquet. Suspendisse potenti. Mauris sed tincidunt mauris, et vulputate risus. Aliquam eget nibh at erat dignissim aliquam non et risus. Fusce mattis neque id diam pulvinar, fermentum luctus enim porttitor. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos."
    # end

  end


  def table_content
    # This makes a call to product_rows and gets back an array of data that will populate the columns and rows of a table
    # I then included some styling to include a header and make its text bold. I made the row background colors alternate between grey and white
    # Then I set the table column widths
    table rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [40, 400, 100]
    end
  end

  def rows
    [['#', 'Name', 'Created']] +
      @group_clients.map do |group|
        [group.id, group.descricao, group.created_at.strftime('%d/%m/%Y')]
      end
  end
end
