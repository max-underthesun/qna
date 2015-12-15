class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  belongs_to :user

  validates :user_id, :title, :body, presence: true
  validates :title, length: { maximum: 150 }

  accepts_nested_attributes_for :attachments
end
