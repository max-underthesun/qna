module AttachmentSerializable
  def attachments
    object.attachments.order_by_creation_asc.map { |a| AttachmentSerializer.new(a, root: false) }
  end
end
