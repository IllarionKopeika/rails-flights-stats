class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: 'Try again later.' }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      flash[:success] = 'Successfully signed in!'
      start_new_session_for user
      redirect_to after_authentication_url
    else
      flash[:danger] = 'Wrong email address and/or password.'
      redirect_to new_session_path
    end
  end

  def destroy
    flash[:warning] = 'Successfully logged out!'
    terminate_session
    redirect_to new_session_path
  end
end
