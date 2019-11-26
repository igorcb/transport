class UsersController < ApplicationController
	before_action :authenticate_user!

	respond_to :html, :js, :json

  def index
    @users = User.order(:id)
		respond_with(@users)
  end

	def edit
    @user = current_user
  end

	def update_password
    @user = User.find(current_user.id)
    if @user.update(user_params)
      # Sign in the user by passing validation in case their password changed
      sign_in @user, :bypass => true
      if @user.has_role? :admin
      	redirect_to root_path, flash: { success: "You updated your account successfully" }
      elsif @user.has_role? :visit
      	redirect_to dashboard_visit_path, flash: { success: "You updated your account successfully" }
			elsif @user.has_role? :boarding
      	redirect_to boardings_path, flash: { success: "You updated your account successfully" }
			elsif @user.has_role? :input
      	redirect_to dasboard_input_path, flash: { success: "You updated your account successfully" }
			elsif @user.has_role? :oper
      	redirect_to dashboard_oper_path, flash: { success: "You updated your account successfully" }
			elsif @user.has_role? :port
      	redirect_to dashboard_port_path, flash: { success: "You updated your account successfully" }
      else
        redirect_to dashboard_agent_path, flash: { success: "You updated your account successfully" }
      end
    else
    	#flash: { danger: "You updated your account successfully" }
      render "edit"
    end
  end

	def toggle_active
		user = User.where(id: params[:id]).first
		user.toggle!(:active)
		redirect_to user_path
	end

	def users_email
    @users = User.order(:email).pluck(:email)
		render inline: @users.inspect
	end


  private

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.required(:user).permit(:name, :employee_id, :active, :password, :password_confirmation, :avatar,
				assets_attributes: [:asset, :id, :_destroy])
  end
end
