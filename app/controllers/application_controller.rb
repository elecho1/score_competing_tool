class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :configure_user_permitted_parameters, if: :devise_controller?
  #before_action :authenticate_user!, if: :use_before_action?
  #before_action :authenticate_user!, :only => [:show]
  protect_from_forgery with: :exception

  private
  def use_before_action?
    true
  end

  def configure_user_permitted_parameters
    # devise_parameter_sanitizer.permit(:sign_in) do |user_params|
    #  user_params.permit(:email, :user_id, :user_name, :open_user_name, :open_score)
    # end
    # devise_parameter_sanitizer.permit(:sign_up) do |user_params|
    #  user_params.permit(:email, :user_id, :user_name, :open_user_name, :open_score)
    # end
    # devise_parameter_sanitizer.permit(:account_update) do |user_params|
    #   user_params.permit(:email, :user_id, :user_name, :open_user_name, :open_score)
    # end

    devise_parameter_sanitizer.permit(:sign_in, keys:[:email, :user_id, :user_name, :open_user_name, :open_score])
    devise_parameter_sanitizer.permit(:sign_up, keys:[:email, :user_id, :user_name, :open_user_name, :open_score])
    devise_parameter_sanitizer.permit(:account_update, keys:[:email, :user_id, :user_name, :open_user_name, :open_score])


  end
  
end
