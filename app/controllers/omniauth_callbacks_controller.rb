class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :authorize_user

  def facebook
  end

  def twitter
  end

  private

  def authorize_user
    epmty_auth = I18n.t('errors.epmty_auth')
    redirect_to(new_user_session_path, alert: epmty_auth) && return unless auth
    @user = OauthAuthenticator.new(auth).find_or_create_user
    if @user && @user.persisted?
      sign_in_user_with_choosen_provider
    else
      ask_user_to_provide_email_and_then_proceed
    end
  end

  def auth
    @auth ||= auth_from_session_attributes || request.env['omniauth.auth']
  end

  def auth_from_session_attributes
    return unless session['devise.auth_attributes']
    OmniAuth::AuthHash.new(
      provider: session['devise.auth_attributes']['provider'],
      uid: session['devise.auth_attributes']['uid'],
      info: { email: params[:email] }
    )
  end

  def sign_in_user_with_choosen_provider
    sign_in_and_redirect @user, event: :authentication
    provider_name = auth.provider.capitalize
    set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
  end

  def ask_user_to_provide_email_and_then_proceed
    session['devise.auth_attributes'] = { provider: auth.provider, uid: auth.uid }
    flash[:info] = I18n.t('info.enter_email')
    render 'omniauth_callbacks/enter_email', locals: { action: auth.provider }
  end
end
