require 'rails_helper'

RSpec.shared_examples "votable_controller" do
  describe 'PATCH #vote_up' do
    describe 'for not signed in user: ' do
      it '- should not add new vote to the resource votes' do
        # original_object = object
        # patch :vote_up, id: object
        # expect(object.vote.reload).to eq original_answer
        expect { patch :vote_up, id: resource, format: :json }
          .to_not change(resource.votes, :count)
      end

      it '- should return 401 (unauthorized) status' do
        patch :vote_up, id: resource, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'for user signed in and not the author of resource: ' do
      before { sign_in(user) }

      it '- should add a new vote to the resource votes' do
        expect { patch :vote_up, id: resource, format: :json }
          .to change(resource.votes, :count).by(1)
      end

      it '- should assign right values to the attributes' do
        patch :vote_up, id: resource, format: :json

        expect(resource.votes.last.votable_id).to eq resource.id
        expect(resource.votes.last.votable_type).to eq resource.class.to_s
        expect(resource.votes.last.user_id).to eq user.id
        expect(resource.votes.last.value).to eq 1
      end
    end

    describe 'for user signed in and author of resource: ' do
      before { sign_in(resource_author) }

      it '- should not add new vote to the resource votes' do
        expect { patch :vote_up, id: resource, format: :json }
          .to_not change(resource.votes, :count)
      end

      it '- should return 422 (unprocessable_entity) status' do
        patch :vote_up, id: resource, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      # context 'with other answer choosen best before' do
      #   let!(:previous_best_answer) {
      #     create(:answer, question: question, user: answer_author, best: best_answer.best)
      #   }

      #   it '- switch previous best answer best status to false' do
      #     patch :best, id: answer, answer: { best: best_answer.best }, format: :js
      #     expect(previous_best_answer.reload.best).to_not eq best_answer.best
      #   end

      #   it '- switch answer best status to true' do
      #     patch :best, id: answer, answer: { best: best_answer.best }, format: :js
      #     expect(answer.reload.best).to eq best_answer.best
      #   end

      #   it '- render answer best template' do
      #     patch :best, id: answer, answer: { best: best_answer.best }, format: :js
      #     expect(response).to render_template :best
      #   end
    end
  end
end
