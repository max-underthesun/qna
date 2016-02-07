require 'rails_helper'

RSpec.shared_examples "votable_controller" do
  describe 'PATCH #vote_up' do
    describe 'for not signed in user: ' do
      it '- should not add new vote to the resource votes' do
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

      context '- vote for the first time' do
        it '-- should add a new vote to the resource votes' do
          expect { patch :vote_up, id: resource, format: :json }
            .to change(resource.votes, :count).by(1)
        end

        it '-- should assign right values to the attributes' do
          patch :vote_up, id: resource, format: :json

          expect(resource.votes.last.votable_id).to eq resource.id
          expect(resource.votes.last.votable_type).to eq resource.class.to_s
          expect(resource.votes.last.user_id).to eq user.id
          expect(resource.votes.last.value).to eq 1
        end
      end

      context '- attempt to vote second time' do
        before { patch :vote_up, id: resource, format: :json }

        it '-- should not add second vote to the resource votes' do
          expect { patch :vote_up, id: resource, format: :json }
            .to_not change(resource.votes, :count)
        end

        it '-- should return 422 (unprocessable_entity) status' do
          patch :vote_up, id: resource, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
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
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PATCH #vote_down' do
    describe 'for not signed in user: ' do
      it '- should not add new vote to the resource votes' do
        expect { patch :vote_down, id: resource, format: :json }
          .to_not change(resource.votes, :count)
      end

      it '- should return 401 (unauthorized) status' do
        patch :vote_down, id: resource, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'for user signed in and not the author of resource: ' do
      before { sign_in(user) }

      context '- vote for the first time' do
        it '-- should add a new vote to the resource votes' do
          expect { patch :vote_down, id: resource, format: :json }
            .to change(resource.votes, :count).by(1)
        end

        it '-- should assign right values to the attributes' do
          patch :vote_down, id: resource, format: :json

          expect(resource.votes.last.votable_id).to eq resource.id
          expect(resource.votes.last.votable_type).to eq resource.class.to_s
          expect(resource.votes.last.user_id).to eq user.id
          expect(resource.votes.last.value).to eq(-1)
        end
      end

      context '- attempt to vote second time' do
        before { patch :vote_down, id: resource, format: :json }

        it '-- should not add second vote to the resource votes' do
          expect { patch :vote_down, id: resource, format: :json }
            .to_not change(resource.votes, :count)
        end

        it '-- should return 422 (unprocessable_entity) status' do
          patch :vote_down, id: resource, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'for user signed in and author of resource: ' do
      before { sign_in(resource_author) }

      it '- should not add new vote to the resource votes' do
        expect { patch :vote_down, id: resource, format: :json }
          .to_not change(resource.votes, :count)
      end

      it '- should return 422 (unprocessable_entity) status' do
        patch :vote_down, id: resource, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #vote_destroy' do
    votes_number = 5
    let!(:votes) { create_list(:vote, votes_number, votable: resource) }
    let(:vote) { votes.sample }
    let(:user) { vote.user }

    describe 'for not signed in user: ' do
      it '- should not destroy any vote in the database' do
        expect(resource.votes.count).to eq(votes_number)
        expect { delete :vote_destroy, id: resource, vote_id: vote, format: :json }
          .to_not change(Vote, :count)
      end

      it '- should return 401 (unauthorized) status' do
        delete :vote_destroy, id: resource, vote_id: vote, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'for user signed in and author of the vote: ' do
      before { sign_in(user) }

      it '-- should destroy a vote from the resource votes' do
        expect(resource.votes.count).to eq(votes_number)
        expect { delete :vote_destroy, id: resource, vote_id: vote, format: :json }
          .to change(resource.votes, :count).by(-1)
      end

      it '-- should destroy right vote' do
        expect(resource.votes.count).to eq(votes_number)
        expect(resource.votes.include?(vote)).to be true

        delete :vote_destroy, id: resource, vote_id: vote, format: :json

        expect(resource.votes.count).to eq(votes_number - 1)
        expect(resource.votes.include?(vote)).to be false
      end
    end

    describe 'for user signed in and not author of the vote: ' do
      before { sign_in(resource_author) }

      it '- should not destroy any vote in the database' do
        expect(resource.votes.count).to eq(votes_number)
        expect { delete :vote_destroy, id: resource, vote_id: vote, format: :json }
          .to_not change(Vote, :count)
      end

      it '- should return 422 (unprocessable_entity) status' do
        delete :vote_destroy, id: resource, vote_id: vote, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
