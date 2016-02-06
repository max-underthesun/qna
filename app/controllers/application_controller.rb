require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    # render status: :forbidden, alert: exception.message
    # redirect_to root_url, alert: exception.message
    if request.format == 'text/javascript'
      render status: :forbidden, alert: exception.message
      # flash[:error] = exception.message
      # render exception.action
    elsif request.format == 'application/json'
      render json: { errors: exception.message }, status: :forbidden
    else
      redirect_to root_url, alert: exception.message
    end
  end

  #check_authorization
end
