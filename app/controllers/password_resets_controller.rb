class PasswordResetsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create instructions edit update ]
  before_action :set_user_by_token, only: %i[ edit update ]

  def new; end

  def create
    user = User.find_by(email_address: params[:email_address])
    if user
      PasswordMailer.with(
        user: user,
        token: user.generate_token_for(:password_reset)
      ).password_reset.deliver_later
    end

    redirect_to instructions_path
  end

  def instructions; end

  def edit; end

  def update
    if @user.update(password_params)
      flash[:success] = t('.password_reset_success')
      redirect_to login_path
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def set_user_by_token
    @user = User.find_by_token_for(:password_reset, params[:token])
    unless @user
      flash[:warning] = t('.invalid_token')
      redirect_to forgot_password_path
    end
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
