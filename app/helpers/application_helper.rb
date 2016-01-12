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
end
