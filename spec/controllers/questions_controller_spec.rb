require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'puts all the questions to the array' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'puts the question to the variable @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'puts a new question to the variable @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves a new question to the database' do
        expect { post :create, question: attributes_for(:question, user: @user) }
          .to change(@user.questions, :count).by(1)
        expect(assigns(:question).user).to eq @user
      end

      it 'redirect to show' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question in the database' do
        expect { post :create, question: attributes_for(:invalid_question, user: @user) }
          .to_not change(Question, :count)
      end

      it 'render new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'question.user == current_user' do
      let(:question) { create(:question, user: @user) }
      before { question }

      it 'delete the question from the database' do
        expect { delete :destroy, id: question }.to change(@user.questions, :count).by(-1)
      end

      it 'redirect to questions path' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context 'question.user != current_user' do
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }
      before { question }

      it 'not delete the question from the database' do
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end

      it 'redirect to questions path' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end
  end
end
