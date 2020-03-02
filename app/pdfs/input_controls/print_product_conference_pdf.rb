module InputControls
  class PrintProductConferencePdf < Prawn::Document
    def initialize(input_control, current_user)
      super()
      @input_control = input_control
      @current_user = current_user
      header
      header_title
      text_info
      text_nfe
      table_content
      footer_text
    end

    def header
      #This inserts an image in the pdf file and sets the size of the image
      #image "#{Rails.root}/app/assets/images/l7-logo.png", width: 128, height: 40
      company = Company.first

      y_position = cursor - 2
      bounding_box([0, y_position], :width => 240, :height => 50) do
        #image company.image.path, width: 128, height: 40
        if company.image.path.present?
          image company.image.path, width: 128, height: 40
        end
      end
      bounding_box([250, y_position], :width => 290, :height => 50) do
        text company.cnpj, :size => 10, align: :right
        text company.razao_social, :size => 10, align: :right
        text company.endereco + ', ' + company.numero, :size => 10, align: :right
        text company.cidade_estado, :size => 10, align: :right
      end
    end

    def header_title
      # The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
      y_position = cursor - 20

      # The bounding_box takes the x and y coordinates for positioning its content and some options to style it
      bounding_box([0, y_position], :width => 540, :height => 90) do
        text "Remessa de Entrada No. #{@input_control.id}", size: 24, align: :center
        text "Listagem de Produtos", size: 18, align: :center
      end
    end

    def text_info
      # The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
      y_position = cursor - 05

      # The bounding_box takes the x and y coordinates for positioning its content and some options to style it
      bounding_box([0, y_position], :width => 540, :height => 30) do
        text "Motorista: #{@input_control.driver.nome}", size: 12
        text "Transportadora: #{@input_control.carrier.nome}", size: 10
      end
    end

    def text_nfe
      # The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
      y_position = cursor - 05

      # The bounding_box takes the x and y coordinates for positioning its content and some options to style it
      bounding_box([0, y_position], :width => 540, :height => 20) do
        text "NF-e: #{@input_control.nfe_xmls.pluck(:numero)}", size: 12
      end
    end

    def table_content
      # This makes a call to product_rows and gets back an array of data that will populate the columns and rows of a table
      # I then included some styling to include a header and make its text bold. I made the row background colors alternate between grey and white
      # Then I set the table column widths
      table rows do
        row(0).font_style = :bold
        self.header = true
        #self.size = 10
        self.cell_style = {size: 10}
        self.row_colors = ['DDDDDD', 'FFFFFF']
        self.column_widths = [60, 300, 50, 42, 42, 42]
      end
    end

    def rows

      [['#', 'Produto', 'Qtde', 'Sobra', 'Falta', 'Avaria']] +
        @input_control.item_input_controls.
        includes(:product).
        select(["products.cod_prod", "products.descricao"]).
          group("products.cod_prod", "products.descricao").sum(:qtde).map do |input|
          ["#{input[0][0]}",
           "#{input[0][1]}",
           "", "", "", ""]
        end
    end

    def footer_text
      # The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
      y_position = cursor - 20

      # The bounding_box takes the x and y coordinates for positioning its content and some options to style it
      bounding_box([0, y_position], :width => 540, :height => 10) do
        text "Impresso por #{@current_user.email} no dia #{Time.now.strftime('%d/%m/%Y as %H:%M')}", size: 7, align: :center
      end
    end

  end
end
