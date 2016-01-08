module VotableController
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up]
    before_action :set_vote, only: [:vote_up]
    # before_action :check_author_of_resource, only: [:vote_up]
  end

  def vote_up
    respond_to do |format|
      if @vote.save
        format.json { render json: { id: @votable.id, rating: @votable.rating } }
      # flash[:notice] = 'nice work'
      else
        format.json { render json: @vote.errors.messages, status: :unprocessable_entity }
        # puts @vote.errors.inspect
      end
      # flash[:alert] = 'something wrong'
    end
    # redirect_to @votable
  end

  private

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def set_vote
    @vote = @votable.votes.new(value: 1, user: current_user)
  end

  # def check_author_of_resource
  #   @vote.forbid_voting if current_user && current_user.author_of?(@votable)
  #   # format.json { render json: @vote.errors.messages, status: :unprocessable_entity }
  #   # render status: :forbidden if current_user.author_of?(@votable)
  # end

  def model_klass
    controller_name.classify.constantize
  end
end
