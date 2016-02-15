require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    let(:question_author) { create(:user) }
    let(:question) { create(:question, user: question_author) }
    let(:comment) { create(:comment, commentable: question) }
    before { comment }

    subject { post :create, question_id: question, comment: attributes_for(:comment), format: :js }

    describe 'for not signed in user: ' do
      it '- it should not add a comment to the database' do
        expect { subject }.to_not change(Comment, :count)
      end

      it '- should return 401 (unauthorized) status' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'for user signed in: ' do
      sign_in_user

      it '- add a comment to the question comments' do
        expect { subject }.to change(question.comments, :count).by(1)
        expect(assigns(:comment).user).to eq @user
      end

      it '- render create template' do
        subject
        expect(response).to render_template :create
      end

      let(:channel) { "/questions/#{question.id}/comments" }

      it_behaves_like "PrivatePub Publishable"
    end
  end
end
