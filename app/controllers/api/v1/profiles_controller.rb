class Api::V1::ProfilesController < Api::V1::BaseController
  # before_action :doorkeeper_authorize!
  # respond_to :json

  def me
    authorize! :me, User

    respond_with current_resource_owner
  end

  def all_except_current
    authorize! :all_except_current, User

    @all_except_current = User.all_except(current_resource_owner)
    respond_with @all_except_current
  end

  # protected

  # def current_resource_owner
  #   @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  # end

  # def current_ability
  #   @ability ||= Ability.new(current_resource_owner)
  # end
end
