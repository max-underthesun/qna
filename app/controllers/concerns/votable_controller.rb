module VotableController
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up]
  end

  def vote_up
  end

  private

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
