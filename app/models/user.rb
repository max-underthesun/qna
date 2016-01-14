class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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
