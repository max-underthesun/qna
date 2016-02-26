module CommentSerializable
  def comments
    object.comments.order_by_creation_asc.map { |a| CommentSerializer.new(a, root: false) }
  end
end
