module InputControls
  class DiferenceArrayService

    def initialize(input_control)
      @input_control = input_control
    end

    def call
      #byebug
      return {success: false, message: "input_control is not present."} if !@input_control.present?
      @item_input_controls = @input_control.item_input_controls.select(:product_id).group(:product_id).sum(:qtde)
      return {success: false, message: "item_input_controls is not present."} if !@item_input_controls.present?
      @conferences = @input_control.conferences
      begin
        # byebug
        ActiveRecord::Base.transaction do
          diference = []
          i=1
          key=0
          @conferences.each do |conference|
            conference_items = conference.conference_items
            if conference_items.count > @item_input_controls.count
              conference_items.each do |conference_item|
                if @item_input_controls[conference_item.product_id].nil?
                  has_product = false
                  z=0
                  diference.each do |dif|
                    if dif[:product_id] == conference_item.product_id
                      has_product = true
                      key = z
                      break
                    end
                    z+=1
                  end

                  if has_product
                    puts ">>>>>>>>>> Yes"
                    puts key
                    diference.push(diference[key].merge({"qtde_oper_#{i}": conference_item.qtde_oper}))
                    diference.delete_at(key)
                  else
                    puts ">>>>>>>>>>>> not"
                    diference.push({product_id: conference_item.product_id, "qtde_oper_#{i}": conference_item.qtde_oper})
                  end
                end
              end
            end
            i+=1
          end
          @diference =  diference
            # return {diference: diference, def: diference[1]}
        end
        return {success: true, message: "Conference on input_control created successfully.", data: @diference}
      rescue => e
        return {success: false, message: e.message}
      end
    end
    private
    def self.verify_if_hash_exists_yet(value=[])
      # if self.present?
      #   dif = false
      #   self.each do |diference|
      #     if diference.product_id == value
      #       return true
      #     end
      #   end
      # end
      return false
    end


  end
end
