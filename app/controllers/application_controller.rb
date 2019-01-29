class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :set_locale

  private

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = if I18n.available_locales.include?(locale)
                    locale
                  else
                    I18n.default_locale
                  end
  end

  private

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".danger"
    redirect_to login_url
  end
end
