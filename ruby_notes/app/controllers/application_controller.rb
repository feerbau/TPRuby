class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  before_action :update_allowed_parameters, if: :devise_controller?
  before_action :authenticate_user!

  def not_found
  	raise ActionController::RoutingError.new('Not Found')
  end

  protected

  def update_allowed_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password)}
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email, :password, :current_password)}
  end
end
