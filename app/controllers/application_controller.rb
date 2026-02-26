class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_location, if: :storable_location?

  protected

  def store_location
    store_location_for(:user, request.fullpath)
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller?
  end

  def configure_permitted_parameters
    keys = %i[first_name last_name address phone_number]
    devise_parameter_sanitizer.permit(:sign_up, keys: keys)
    devise_parameter_sanitizer.permit(:account_update, keys: keys)
  end
end
