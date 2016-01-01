class Question < ActiveRecord::Base
  include Votable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :user_id, :title, :body, presence: true
  validates :title, length: { maximum: 150 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
