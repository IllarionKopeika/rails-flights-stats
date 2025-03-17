class PasswordsController < ApplicationController
  def change_password; end

  def update_password
    if Current.user.update(password_params)
      flash[:success] = t('.change_password_success')
      redirect_to root_path
    else
      render 'change_password', status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :password_challenge).with_defaults(password_challenge: '')
  end
end
