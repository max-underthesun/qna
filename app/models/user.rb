class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_questions, through: :subscriptions, source: :question # class_name: 'Question'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  scope :all_except, ->(user) { where.not(id: user) }

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.digest(user).deliver_later
    end
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

  def not_author_of?(object)
    !author_of?(object)
  end

  private

  def not_voted_yet_for?(object)
    !voted_for?(object)
  end
end
