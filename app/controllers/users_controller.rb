class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  def show
    @user = Current.user
    @stats = @user.general_stat
    completed_flights = @user.flights.where(status: :completed)
    @airports = completed_flights.pluck(:departure_airport_id, :arrival_airport_id).flatten.uniq.count
    @airlines = completed_flights.select(:airline_id).distinct.count
    @aircrafts = completed_flights.select(:aircraft_id).distinct.count
    visits = @user.visits
    @countries = visits.where(visitable_type: 'Country').select(:visitable_id).distinct.count
    @regions = visits.where(visitable_type: 'Region').select(:visitable_id).distinct.count
  end

  def new
    if authenticated?
      flash[:info] = t('.already_signed_up')
      redirect_to root_path
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t('.signup_success')
      redirect_to root_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation, :name)
  end
end
