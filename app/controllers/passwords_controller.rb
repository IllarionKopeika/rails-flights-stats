class PasswordsController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create, :edit, :update ]
  before_action :set_user_by_token, only: [ :edit, :update ]

  def new
  end

  def create
    if user = User.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to login_path, notice: "Password reset instructions sent (if user with that email address exists)."
  end

  def edit
  end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      redirect_to login_path, notice: "Password has been reset."
    else
      redirect_to edit_password_path(params[:token]), alert: "Passwords did not match."
    end
  end

  def change_password
  end

  def update_password
    if Current.user.update(password_params)
      flash[:success] = t('.change_password_success')
      redirect_to profile_path
    else
      render 'change_password', status: :unprocessable_entity
    end
  end

  private

  def set_user_by_token
    @user = User.find_by_password_reset_token!(params[:token])
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_password_path, alert: "Password reset link is invalid or has been expired."
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :password_challenge).with_defaults(password_challenge: '')
  end
end
