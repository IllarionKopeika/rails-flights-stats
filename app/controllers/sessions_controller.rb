class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { flash[:danger] = t('.try_later')
                                                                  redirect_to login_path
                                                                }

  def new
    if authenticated?
      flash[:info] = t('.already_logged_in')
      redirect_to root_path
    end
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      flash[:success] = t('.login_success')
      start_new_session_for user
      redirect_to after_authentication_url
    else
      flash[:danger] = t('.login_fail')
      redirect_to login_path
    end
  end

  def destroy
    flash[:info] = t('.logout_success')
    terminate_session
    redirect_to login_path
  end
end
