class PagesController < ApplicationController
  before_action :set_locale

  def home; end

  def help; end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
