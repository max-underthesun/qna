module VotableController
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up]
  end

  def vote_up
    vote = @votable.votes.new(value: 1, user: current_user)
    if vote.save
      flash[:notice] = 'nice work'
    else
      flash[:alert] = 'something wrong'
    end
    redirect_to @votable
  end

  private

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
