# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # current year to be used throughout app controllers
  CURRENT_YEAR = Time.now.getlocal.year

  protected

  def configure_permitted_parameters
    # permit :name parameter along with other sign_up parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
