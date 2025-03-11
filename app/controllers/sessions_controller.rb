class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { flash[:warning] = t('.try_later')
                                                                  redirect_to new_session_url
                                                                }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      flash[:success] = t('.login_success')
      start_new_session_for user
      redirect_to after_authentication_url
    else
      flash[:danger] = t('.login_fail')
      redirect_to new_session_path
    end
  end

  def destroy
    flash[:success] = t('.logout_success')
    terminate_session
    redirect_to new_session_path
  end
end
