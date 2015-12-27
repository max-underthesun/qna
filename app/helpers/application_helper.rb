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
end
