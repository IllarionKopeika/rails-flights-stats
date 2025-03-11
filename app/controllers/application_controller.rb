class ApplicationController < ActionController::Base
  include Authentication

  before_action :set_locale
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def default_url_options
    { locale: I18n.locale }
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def not_found(exception)
    logger.warn exception
    render file: 'public/404.html', status: :not_found, layout: false
  end
end
