require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    if request.format == 'text/javascript'
      render status: :forbidden, alert: exception.message
    elsif request.format == 'application/json'
      render json: { errors: exception.message }, status: :forbidden
    else
      redirect_to root_url, alert: exception.message
    end
  end

  check_authorization unless: :devise_controller?
end
