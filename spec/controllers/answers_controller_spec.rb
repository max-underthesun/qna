require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new' do
    before { get :new, question_id: question }

    it 'puts the question to the variable @question' do
      expect(assigns(:question)).to eq question
    end

    it 'puts a new Answer in to the @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer to the database' do
        expect {
          post :create, question_id: question,
                        answer: attributes_for(:answer, question_id: question)
        }.to change(Answer, :count).by(1)
      end

      it 'redirect to answer question show view' do
        post :create, question_id: question, answer: attributes_for(:answer, question_id: question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'puts the question to the variable @question' do
        post :create, question_id: question,
                      answer: attributes_for(:invalid_answer, question_id: question)
        expect(assigns(:question)).to eq question
      end

      it 'does not save an answer' do
        expect {
          post :create, question_id: question,
                        answer: attributes_for(:invalid_answer, question_id: question)
        }.to_not change(Answer, :count)
      end

      it 'render new view' do
        post :create, question_id: question,
                      answer: attributes_for(:invalid_answer, question_id: question)
        expect(response).to render_template :new
      end
    end
  end
end
