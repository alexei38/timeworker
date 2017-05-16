class ApplicationController < ActionController::Base

  layout :layout_by_resource

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_filter :authenticate_user!
  protect_from_forgery

  protected

  def layout_by_resource
    if devise_controller?
      "login"
    else
      "application"
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :fio, :admin])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :fio, :admin])
  end

end
