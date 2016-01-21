require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  # let(:question_author) { create(:user) }
  # let(:question) { create(:question, user: question_author) }

  # describe 'POST #create' do
  #   sign_in_user

  #   context 'with valid attributes' do
  #     it 'saves a new comment to the database' do
  #       expect {
  #         post :create, question_id: question, answer: attributes_for(:answer), format: :js
  #       }.to change(question.answers, :count).by(1)
  #       expect(assigns(:answer).user).to eq @user
  #     end

  #     it 'render create template' do
  #       post :create, question_id: question, answer: attributes_for(:answer), format: :js
  #       expect(response).to render_template :create
  #     end
  #   end

  #   context 'with invalid attributes' do
  #     it 'puts the question to the variable @question' do
  #       post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
  #       expect(assigns(:question)).to eq question
  #     end

  #     it 'does not save an answer' do
  #       expect {
  #         post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
  #       }.to_not change(Answer, :count)
  #     end

  #     it 'redirect to question show view' do
  #       post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
  #       expect(response).to render_template :create
  #     end
  #   end
  # end

  describe 'POST #create' do
    let(:question_author) { create(:user) }
    let(:question) { create(:question, user: question_author) }
    let(:comment) { create(:comment, commentable: question) }
    before { comment }

    describe 'for not signed in user: ' do
      it '- it should not add a comment to the database' do
        expect {
          post :create, question_id: question, comment: attributes_for(:comment), format: :js
        }.to_not change(Comment, :count)
      end

      it '- should return 401 (unauthorized) status' do
        post :create, question_id: question, comment: attributes_for(:comment), format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'for user signed in: ' do
      sign_in_user

      it '- add a comment to the question comments' do
        expect {
          post :create, question_id: question, comment: attributes_for(:comment), format: :js
        }.to change(question.comments, :count).by(1)
        expect(assigns(:comment).user).to eq @user
      end

      it '- render create template' do
        post :create, question_id: question, comment: attributes_for(:comment), format: :js
        expect(response).to render_template :create
      end
    end
  end
end
