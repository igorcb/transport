module CommentsService

  #def

  # class CommentsService
  #
  #   def initialize(boarding)
  #     @boarding = boarding
  #   end
  #
  #   def call
  #     #byebug
  #     return {success: false, message: "Boarding is not found."} if !@conference.present?
  #
  #     begin
  #       # byebug
  #       ActiveRecord::Base.transaction do
  #         #@conference.update(finish_time: Time.current, status: :finish, approved: :waiting)
  #       end
  #       return {success: true, message: "Conference on input_control created successfully."}
  #     rescue => e
  #       return {success: false, message: e.message}
  #     end
  #   end
  # end

end
