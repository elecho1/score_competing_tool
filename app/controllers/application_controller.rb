class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :configure_user_permitted_parameters, if: :devise_controller?
  #before_action :authenticate_user!, if: :use_before_action?
  before_action :authenticate_user!, :only => [:show]
  protect_from_forgery with: :exception

  private
  def use_before_action?
    true
  end

  def configure_user_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :email])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email])
  end
  
end
