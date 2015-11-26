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
        expect { post :create, question_id: question, answer: attributes_for(:answer) }
          .to change(question.answers, :count).by(1)
        expect(assigns(:answer).user).to eq @user
      end

      it 'redirect to question show view' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'puts the question to the variable @question' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(assigns(:question)).to eq question
      end

      it 'does not save an answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer) }
          .to_not change(Answer, :count)
      end

      it 'redirect to question show view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'answer.user == current_user' do
      let(:answer) { create(:answer, question: question, user: @user) }
      before { answer }

      it 'delete the answer from the database' do
        expect { delete :destroy, question_id: question, id: answer }
          .to change(@user.answers, :count).by(-1)
      end

      it 'redirect to question show' do
        delete :destroy, question_id: question, id: answer
        expect(response).to redirect_to question
      end
    end

    context 'answer.user != current_user' do
      let(:user) { create(:user) }
      let(:answer) { create(:answer, question: question, user: user) }
      before { answer }

      it 'not delete the answer from the database' do
        expect { delete :destroy, question_id: question, id: answer }
          .to_not change(Answer, :count)
      end

      it 'redirect to question show' do
        delete :destroy, question_id: question, id: answer
        expect(response).to redirect_to question
      end
    end
  end
end
