class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    authorize! :me, User

    respond_with current_resource_owner
  end

  def all_except_current
    authorize! :all_except_current, User

    @all_except_current = User.all_except(current_resource_owner)
    respond_with @all_except_current
  end
end
