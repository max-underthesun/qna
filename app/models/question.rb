class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :user_id, :title, :body, presence: true
  validates :title, length: { maximum: 150 }
end
