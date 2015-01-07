class UsersController < ApplicationController
	before_filter :authenticate_user!

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
      else
      	redirect_to dashboard_path, flash: { success: "You updated your account successfully" }
      end
    else
    	#flash: { danger: "You updated your account successfully" }
      render "edit"
    end
  end  

  private

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.required(:user).permit(:password, :password_confirmation)
  end
end
