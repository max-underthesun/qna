class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :authorize_user

  def facebook
  end

  private

  def authorize_user
    auth = request.env['omniauth.auth']
    return unless auth
    @user = User.find_for_oauth(auth)
    return unless @user.persisted?
    sign_in_and_redirect @user, event: :authentication
    return unless is_navigational_format?
    set_flash_message(:notice, :success, kind: "#{action_name}".capitalize)
  end
end
