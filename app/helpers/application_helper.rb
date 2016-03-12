module ApplicationHelper
  def render_errors_for(resource, remotipart_submitted)
    if remotipart_submitted
      j "#{render 'common/errors', resource: resource}"
    else
      j render 'common/errors', resource: resource
    end
  end

  def render_resource(resource, remotipart_submitted)
    if remotipart_submitted
      j "#{render resource}"
    else
      j render resource
    end
  end

  def name_of(resource)
    resource.class.to_s.downcase
  end

  def vote_visibility(resource)
    (!current_user || (current_user.can_vote?(resource))) ? 'block' : 'none'
  end

  def vote_destroy_visibility(resource)
    (current_user && current_user.voted_for?(resource)) ? 'block' : 'none'
  end

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
