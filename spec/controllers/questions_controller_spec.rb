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

    it 'puts a new answer to the variable @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
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
      subject { post :create, question: attributes_for(:question, user: @user) }

      it 'saves a new question to the database' do
        expect { subject }.to change(@user.questions, :count).by(1)
      end

      it 'redirect to show' do
        subject
        expect(response).to redirect_to question_path(assigns(:question))
      end

      let(:channel) { "/questions" }

      it_behaves_like "PrivatePub Publishable"
    end

    context 'with invalid attributes' do
      subject { post :create, question: attributes_for(:invalid_question, user: @user) }

      it 'does not save the question in the database' do
        expect { subject }.to_not change(Question, :count)
      end

      it 'render new view' do
        subject
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:question_author) { create(:user) }
    let(:resource) { create(:question, user: question_author) }
    let(:updated_resource) { build(:question) }
    let(:resource_name ) { 'question' }
    let(:resource_attributes) { %w(title body) }

    let (:request) do
      patch :update,
            id: resource,
            question: { title: updated_resource.title, body: updated_resource.body },
            format: :js
    end

    let (:request_with_invalid_attributes) do
      patch :update, id: resource, question: attributes_for(:invalid_question), format: :js
    end

    it_behaves_like "updatable resource"
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
        expect(response).to redirect_to root_url
      end
    end
  end

  describe 'for vote actions' do
    let(:resource_author) { create(:user) }
    let(:user) { create(:user) }
    let(:resource) { create(:question, user: resource_author) }

    it_behaves_like "votable_controller"
  end
end
