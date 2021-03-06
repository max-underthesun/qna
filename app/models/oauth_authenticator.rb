class OauthAuthenticator
  include ActiveModel::Validations

  validates :provider, :uid, presence: true

  def initialize(auth)
    @provider = auth.provider
    @uid = auth.uid
    @email = auth.info[:email] if auth.info.try(:email)
  end

  def find_or_create_user
    return @user if user_exists_and_already_has_authorization?
    return unless email
    if user_exists_but_has_no_authorization?
      create_authorization
    else
      create_new_user
      create_authorization
    end
    @user
  end

  private

  attr_reader :provider, :uid, :email

  def user_exists_and_already_has_authorization?
    authorization = Authorization.where(provider: provider, uid: uid.to_s).first
    @user = authorization.user if authorization
  end

  def user_exists_but_has_no_authorization?
    @user = User.where(email: email).first
  end

  def create_new_user
    password = Devise.friendly_token[0, 20]
    @user = User.create!(email: email, password: password, password_confirmation: password)
  end

  def create_authorization
    @user.authorizations.create(provider: provider, uid: uid)
  end
end
