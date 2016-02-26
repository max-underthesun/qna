class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true

  validates :file, presence: true

  # default_scope { order(created_at: :asc) }
  scope :order_by_creation_asc, -> { order(created_at: :asc) }

  mount_uploader :file, FileUploader
end
