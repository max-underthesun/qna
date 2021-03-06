require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question_author) { create(:user) }
  let(:question) { create(:question, user: question_author) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      subject { post :create, question_id: question, answer: attributes_for(:answer), format: :js }

      it 'saves a new answer to the database' do
        expect { subject }.to change(question.answers, :count).by(1)
        expect(assigns(:answer).user).to eq @user
      end

      it 'render create template' do
        subject
        expect(response).to render_template :create
      end

      let(:channel) { "/questions/#{question.id}/answers" }
      let(:answer) { create(:answer, question: question) }
      let(:resource_klass) { Answer }
      let(:resource) { answer }
      let(:args) do
        { answer: answer.to_json, rating: "0", author: @user.email.to_json, attachments: "[]" }
      end

      it_behaves_like "PrivatePub Publishable"
    end

    context 'with invalid attributes' do
      subject do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
      end

      it 'puts the question to the variable @question' do
        subject
        expect(assigns(:question)).to eq question
      end

      it 'does not save an answer' do
        expect { subject }.to_not change(Answer, :count)
      end

      it 'redirect to question show view' do
        subject
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer_author) { create(:user) }
    let(:resource) { create(:answer, question: question, user: answer_author) }
    let(:updated_resource) { build(:answer) }
    let(:resource_name) { 'answer' }
    let(:resource_attributes) { %w(body) }

    let(:request) do
      patch :update, id: resource, answer: { body: updated_resource.body }, format: :js
    end

    let(:request_with_invalid_attributes) do
      patch :update, id: resource, answer: attributes_for(:invalid_answer), format: :js
    end

    it_behaves_like "updatable resource"
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
