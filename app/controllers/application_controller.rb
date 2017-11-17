class ApplicationController < ActionController::Base

  # basic confirmation 
  before_action :http_basic_authenticate

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :configure_user_permitted_parameters, if: :devise_controller?
  #before_action :authenticate_user!, if: :use_before_action?
  protect_from_forgery with: :exception

  private
  def use_before_action?
    true
  end

  def configure_user_permitted_parameters
    # devise_parameter_sanitizer.permit(:sign_in) do |user_params|
    #  user_params.permit(:email, :user_key, :user_name, :open_user_name, :open_score)
    # end
    # devise_parameter_sanitizer.permit(:sign_up) do |user_params|
    #  user_params.permit(:email, :user_key, :user_name, :open_user_name, :open_score)
    # end
    # devise_parameter_sanitizer.permit(:account_update) do |user_params|
    #   user_params.permit(:email, :user_key, :user_name, :open_user_name, :open_score)
    # end

    devise_parameter_sanitizer.permit(:sign_in, keys:[:provider, :uid, :slack_enabled_flag])
    devise_parameter_sanitizer.permit(:sign_up, keys:[])
    devise_parameter_sanitizer.permit(:account_update, keys:[:email, :user_key, :user_name, :open_user_name, :open_score, :provider, :uid, :slack_enabled_flag, :department, :lab_id, :open_lab])
  end

  def http_basic_authenticate
    #authenticate_or_request_with_http_basic  do |name, password|
    #  name == ENV['BASIC_AUTH_USERNAME'] && password == ENV['BASIC_AUTH_PASSWORD']
    #end
  end


  # changed where to redirect to after sign-in
  #def after_sign_in_path_for(resource)
  #  table_path
  #end
  
end
