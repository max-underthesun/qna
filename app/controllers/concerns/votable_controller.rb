module VotableController
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up]
    before_action :new_vote, only: [:vote_up]
  end

  def vote_up
    respond_to do |format|
      if @vote.save
        format.json { render json: { id: @votable.id, rating: @votable.rating } }
      else
        format.json { render json: @vote.errors.messages, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def new_vote
    @vote = @votable.votes.new(value: 1, user: current_user)
  end

  def model_klass
    controller_name.classify.constantize
  end
end
