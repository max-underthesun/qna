module VotableController
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down, :vote_destroy]
  end

  def vote_up
    authorize! :vote_up, @votable

    new_vote_with_value(1)
    respond_to do |format|
      if @vote.save
        format.json { render json: { id: @votable.id, rating: @votable.rating } }
      else
        format.json { render json: @vote.errors.messages, status: :unprocessable_entity }
      end
    end
  end

  def vote_down
    authorize! :vote_down, @votable

    new_vote_with_value(-1)
    respond_to do |format|
      if @vote.save
        format.json { render json: { id: @votable.id, rating: @votable.rating } }
      else
        format.json { render json: @vote.errors.messages, status: :unprocessable_entity }
      end
    end
  end

  def vote_destroy
    authorize! :vote_destroy, @votable

    @vote = @votable.votes.find_by(user: current_user)
    @vote.destroy
    respond_to do |format|
      # if @vote && @vote.destroy
        format.json { render json: { id: @votable.id, rating: @votable.rating } }
      # else
      #   format.json do
      #     render json: { id: @votable.id, rating: @votable.rating },
      #            status: :unprocessable_entity
      #   end
      # end
    end
  end

  private

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def new_vote_with_value(value)
    @vote = @votable.votes.new(value: value, user: current_user)
  end

  def model_klass
    controller_name.classify.constantize
  end
end
