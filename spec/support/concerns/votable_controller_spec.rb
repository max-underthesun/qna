require 'rails_helper'

RSpec.shared_examples "votable_controller" do
  describe 'PATCH #vote_up' do
    describe 'for not signed in user: ' do
      it '- should not add new vote to the resource votes' do
        # original_object = object
        # patch :vote_up, id: object
        # expect(object.vote.reload).to eq original_answer
        expect { patch :vote_up, id: resource }.to_not change(resource.votes, :count)
      end

      it '- should return 401 (unauthorized) status' do
        patch :vote_up, id: resource
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'for user signed in and not the author of resource: ' do
      before { sign_in(user) }

      it '- should add a new vote to the resource votes' do
        expect { patch :vote_up, id: resource }.to change(resource.votes, :count).by(1)
      end

      # it '- should return 403 (forbidden) status' do
      #   patch :best, id: answer, answer: { best: best_answer.best }, format: :js
      #   expect(response).to have_http_status(:forbidden)
      # end
    end

  #   describe 'for user signed in and author of question: ' do
  #     sign_in_user
  #     let(:question) { create(:question, user: @user) }
  #     let(:answer) { create(:answer, question: question, user: answer_author) }

  #     context 'with no best answer choosen before' do
  #       it '- switch answer best status to true' do
  #         patch :best, id: answer, answer: { best: best_answer.best }, format: :js
  #         expect(answer.reload.best).to eq best_answer.best
  #       end

  #       it '- render answer best template' do
  #         patch :best, id: answer, answer: { best: best_answer.best }, format: :js
  #         expect(response).to render_template :best
  #       end
  #     end

  #     context 'with other answer choosen best before' do
  #       let!(:previous_best_answer) {
  #         create(:answer, question: question, user: answer_author, best: best_answer.best)
  #       }

  #       it '- switch previous best answer best status to false' do
  #         patch :best, id: answer, answer: { best: best_answer.best }, format: :js
  #         expect(previous_best_answer.reload.best).to_not eq best_answer.best
  #       end

  #       it '- switch answer best status to true' do
  #         patch :best, id: answer, answer: { best: best_answer.best }, format: :js
  #         expect(answer.reload.best).to eq best_answer.best
  #       end

  #       it '- render answer best template' do
  #         patch :best, id: answer, answer: { best: best_answer.best }, format: :js
  #         expect(response).to render_template :best
  #       end
  #     end
  #   end
  end
end
