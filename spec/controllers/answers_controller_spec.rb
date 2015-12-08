require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  # describe 'GET #new' do
  #   sign_in_user
  #   before { get :new, question_id: question }

  #   it 'puts the question to the variable @question' do
  #     expect(assigns(:question)).to eq question
  #   end

  #   it 'puts a new Answer in to the @answer' do
  #     expect(assigns(:answer)).to be_a_new(Answer)
  #   end

  #   it 'render new view' do
  #     expect(response).to render_template :new
  #   end
  # end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves a new answer to the database' do
        expect {
          post :create, question_id: question, answer: attributes_for(:answer), format: :js
        }.to change(question.answers, :count).by(1)
        expect(assigns(:answer).user).to eq @user
      end

      it 'render create template' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'puts the question to the variable @question' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'does not save an answer' do
        expect {
          post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        }.to_not change(Answer, :count)
      end

      it 'redirect to question show view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer_author) { create(:user) }
    let(:answer) { create(:answer, question: question, user: answer_author) }
    let(:updated_answer) { build(:answer) }

    describe 'for not signed in user: ' do
      # it '- should not update question' do
      #   expect {
      #     patch :update, id: question,
      #       question: { title: updated_question.title, body: updated_question.body }, format: :js
      #   }.to_not change { question.reload }
      # end

      it '- should not update answer' do
        original_answer = answer
        patch :update, id: answer, answer: { body: updated_answer.body }, format: :js
        # expect(assigns(:question).title).to eq original_title
        # question.reload

        expect(answer.reload).to eq original_answer # ?????
      end

      it '- should return 401 (unauthorized) status' do
        patch :update, id: answer, answer: { body: updated_answer.body }, format: :js
        expect(response).to have_http_status(:unauthorized)
        # expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'for user signed in but not the author: ' do
      sign_in_user

      it '- should not update answer' do
        original_answer = answer
        patch :update, id: answer, answer: { body: updated_answer.body }, format: :js

        expect(answer.reload).to eq original_answer # ?????
        # expect {
        #   patch :update, id: question, question: attributes_for(:question), format: :js
        # }.to_not change { question.reload }
      end

      it '- should return 401 (unauthorized) status' do
        patch :update, id: answer, answer: { body: updated_answer.body }, format: :js

        expect(response).to have_http_status(:unauthorized)
        # expect(response).to redirect_to question_path(question)
      end
    end

    describe 'for user signed in and author: ' do
      sign_in_user

      context 'with valid attributes' do
        let(:answer) { create(:answer, question: question, user: @user) }

        it '- assigns answer to @answer' do
          patch :update, id: answer, answer: { body: updated_answer.body }, format: :js
          expect(assigns(:answer)).to eq answer
        end

        # it '- change the question title' do
        #   patch :update, id: question, question: { title: updated_question.title }, format: :js
        #   question.reload
        #   expect(assigns(:question).title).to eq updated_question.title
        # end

        it '- change the answer body' do
          patch :update, id: answer, answer: { body: updated_answer.body }, format: :js
          answer.reload
          expect(assigns(:answer).body).to eq updated_answer.body
        end

        # it '- change the question' do
        #   expect {
        #     patch :update, id: question,
        #       question: { title: updated_question.title }, format: :js
        #   }.to change { question.reload }
        # end

        it '- render answer update template' do
          patch :update, id: answer, answer: { body: updated_answer.body }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it '- should not update answer' do
          # expect {
          #   patch :update, id: question, question: attributes_for(:invalid_question), format: :js
          # }.to_not change { question }
          original_answer = answer
          patch :update, id: answer, answer: attributes_for(:invalid_answer), format: :js
          # expect(question.reload).to_not eq original_question
          expect(assigns(:answer)).to eq original_answer
        end

        it '- render answer update template' do
          patch :update, id: answer, answer: attributes_for(:invalid_answer), format: :js
          expect(response).to render_template :update
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'answer.user == current_user' do
      let(:answer) { create(:answer, question: question, user: @user) }
      before { answer }

      it 'delete the answer from the database' do
        expect { delete :destroy, question_id: question, id: answer, format: :js }
          .to change(@user.answers, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, question_id: question, id: answer, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'answer.user != current_user' do
      let(:user) { create(:user) }
      let(:answer) { create(:answer, question: question, user: user) }
      before { answer }

      it 'not delete the answer from the database' do
        expect { delete :destroy, question_id: question, id: answer, format: :js }
          .to_not change(Answer, :count)
      end

      it 'render destroy template' do
        delete :destroy, question_id: question, id: answer, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
