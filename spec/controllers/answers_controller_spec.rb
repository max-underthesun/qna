require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question_author) { create(:user) }
  let(:question) { create(:question, user: question_author) }

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
      it '- should not update answer' do
        original_answer = answer
        patch :update, id: answer, answer: { body: updated_answer.body }, format: :js
        expect(answer.reload).to eq original_answer
      end

      it '- should return 401 (unauthorized) status' do
        patch :update, id: answer, answer: { body: updated_answer.body }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'for user signed in but not the author: ' do
      sign_in_user

      it '- should not update answer' do
        original_answer = answer
        patch :update, id: answer, answer: { body: updated_answer.body }, format: :js
        expect(answer.reload).to eq original_answer
      end

      it '- should return 403 (forbidden) status' do
        patch :update, id: answer, answer: { body: updated_answer.body }, format: :js
        expect(response).to have_http_status(:forbidden)
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

        it '- change the answer body' do
          patch :update, id: answer, answer: { body: updated_answer.body }, format: :js
          answer.reload
          expect(assigns(:answer).body).to eq updated_answer.body
        end

        it '- render answer update template' do
          patch :update, id: answer, answer: { body: updated_answer.body }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it '- should not update answer' do
          original_answer = answer
          patch :update, id: answer, answer: attributes_for(:invalid_answer), format: :js
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
    let(:answer_author) { create(:user) }
    let(:answer) { create(:answer, question: question, user: answer_author) }

    describe 'for not signed in user: ' do
      before { answer }

      it '- it should not delete the answer from the database' do
        expect { delete :destroy, question_id: question, id: answer, format: :js }
          .to_not change(Answer, :count)
      end

      it '- should return 401 (unauthorized) status' do
        delete :destroy, question_id: question, id: answer, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'for user signed in but no the author:' do
      sign_in_user
      before { answer }

      it '- it should not delete the answer from the database' do
        expect { delete :destroy, question_id: question, id: answer, format: :js }
          .to_not change(Answer, :count)
      end

      it '- should return 403 (forbidden) status' do
        delete :destroy, question_id: question, id: answer, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'for user signed in and author: ' do
      sign_in_user
      let(:answer) { create(:answer, question: question, user: @user) }
      before { answer }

      it '- delete the answer from the database' do
        expect { delete :destroy, question_id: question, id: answer, format: :js }
          .to change(@user.answers, :count).by(-1)
      end

      it '- render destroy template' do
        delete :destroy, question_id: question, id: answer, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #best' do
    let(:answer_author) { create(:user) }
    let(:answer) { create(:answer, question: question, user: answer_author) }
    let(:best_answer) { build(:answer, question: question, user: answer_author, best: true) }

    describe 'for not signed in user: ' do
      it '- should not update answer best status' do
        original_answer = answer
        patch :best, id: answer, answer: { best: best_answer.best }, format: :js
        expect(answer.reload).to eq original_answer
      end

      it '- should return 401 (unauthorized) status' do
        patch :best, id: answer, answer: { best: best_answer.best }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'for user signed in but not the author of question: ' do
      sign_in_user

      it '- should not update answer best status' do
        original_answer = answer
        patch :best, id: answer, answer: { best: best_answer.best }, format: :js
        expect(answer.reload).to eq original_answer
      end

      it '- should return 403 (forbidden) status' do
        patch :best, id: answer, answer: { best: best_answer.best }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'for user signed in and author of question: ' do
      sign_in_user
      let(:question) { create(:question, user: @user) }
      let(:answer) { create(:answer, question: question, user: answer_author) }

      context 'with no best answer choosen before' do
        it '- switch answer best status to true' do
          patch :best, id: answer, answer: { best: best_answer.best }, format: :js
          expect(answer.reload.best).to eq best_answer.best
        end

        it '- render answer best template' do
          patch :best, id: answer, answer: { best: best_answer.best }, format: :js
          expect(response).to render_template :best
        end
      end

      context 'with other answer choosen best before' do
        let!(:previous_best_answer) {
          create(:answer, question: question, user: answer_author, best: best_answer.best)
        }

        it '- switch previous best answer best status to false' do
          patch :best, id: answer, answer: { best: best_answer.best }, format: :js
          expect(previous_best_answer.reload.best).to_not eq best_answer.best
        end

        it '- switch answer best status to true' do
          patch :best, id: answer, answer: { best: best_answer.best }, format: :js
          expect(answer.reload.best).to eq best_answer.best
        end

        it '- render answer best template' do
          patch :best, id: answer, answer: { best: best_answer.best }, format: :js
          expect(response).to render_template :best
        end
      end
    end
  end

  describe 'for vote actions' do
    let(:resource_author) { create(:user) }
    let(:user) { create(:user) }
    let(:resource) { create(:answer, user: resource_author) }

    it_behaves_like "votable_controller"
  end
end
