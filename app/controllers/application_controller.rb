
class ApplicationController < ActionController::Base
  DEMO_EMAIL =  Rails.application.secrets[:admin_email] # Secrecy is pointless!

  protect_from_forgery with: :exception

  before_action :authenticate_user!

  helper_method :demo_user?

  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  # Devise suggested workround to allow extra 'name' field in user forms
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])

    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def demo_user?
    user_signed_in? and current_user.email == DEMO_EMAIL
  end
end
