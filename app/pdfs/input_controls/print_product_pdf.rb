module InputControls
  class PrintProductPdf < Prawn::Document
    def initialize(input_control)
      super()
      @input_control = input_control
      header
      header_title
      table_content
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

    def header_title
      # The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
      y_position = cursor - 20

      # The bounding_box takes the x and y coordinates for positioning its content and some options to style it
      bounding_box([0, y_position], :width => 540, :height => 90) do
        text "Remessa de Entrada No. #{@input_control.id}", size: 24, align: :center
        text "Listagem de Produtos", size: 18, align: :center
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
        self.cell_style = {size: 12}
        self.row_colors = ['DDDDDD', 'FFFFFF']
        self.column_widths = [60, 360, 100]
      end
    end

    def rows

      [['#', 'Produto', 'Qtde']] +
        @input_control.item_input_controls.
        includes(:product).
        select(["products.cod_prod", "products.descricao"]).
          group("products.cod_prod", "products.descricao").sum(:qtde).map do |input|
          ["#{input[0][0]}",
           "#{input[0][1]}",
           "#{input[1].to_f}"]
        end
    end

  end
end
