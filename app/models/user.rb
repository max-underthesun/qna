class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first
    if user
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    end
    user
  end

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

  def not_author_of?(object)
    !author_of?(object)
  end

  def not_voted_yet_for?(object)
    !voted_for?(object)
  end
end
