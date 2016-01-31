class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  def self.find_for_oauth(auth)
    @email = auth.info[:email] if auth.info.try(:email)

    if user_exists_and_already_has_authorization?(auth)
      return @user
    elsif user_exists_but_has_no_authorization?
      create_authorization(auth)
    else
      return unless @email
      create_a_new_user
      create_authorization(auth)
    end
    @user

    # authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    # return authorization.user if authorization

    # email = auth.info[:email]
    # user = User.where(email: email).first
    # if user
    #   user.authorizations.create(provider: auth.provider, uid: auth.uid)
    # else
    #   password = Devise.friendly_token[0, 20]
    #   user = User.create!(email: email, password: password, password_confirmation: password)
    #   user.authorizations.create(provider: auth.provider, uid: auth.uid)
    # end
    # user
  end

  # def self.new_with_session(params, session)
  #   if session["devise.auth_attributes"]
  #     new(params) do |user|
  #       @provider = user.authorizations.find_by(provider: session['devise.auth_attributes'][:provider])
  #     end
  #   else
  #     super
  #   end
  # end

  # def password_required?
  #   # super && authorizations.blank?
  #   super && authorizations.find_by(@provider).blank?
  # end

  def author_of?(object)
    object.user_id == id
  end

  def can_vote?(object)
    not_author_of?(object) && not_voted_yet_for?(object)
  end

  def voted_for?(object)
    (votes.where(votable: object)).present?
  end

  private

  def self.user_exists_and_already_has_authorization?(auth)
    @authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    @user = @authorization.user if @authorization
  end

  def self.user_exists_but_has_no_authorization?
    @user = User.where(email: @email).first
  end

  def self.create_a_new_user
    password = Devise.friendly_token[0, 20]
    @user = User.create!(email: @email, password: password, password_confirmation: password)
  end

  def self.create_authorization(auth)
    @user.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def not_author_of?(object)
    !author_of?(object)
  end

  def not_voted_yet_for?(object)
    !voted_for?(object)
  end
end
