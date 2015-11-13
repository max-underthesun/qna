require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    it 'puts all the questions to the array' do
      question_1 = create(:question)
      question_2 = create(:question)

      get :index

      expect(assigns(:questions)).to match_array([question_1, question_2])
    end

    it 'render index view' do
      get :index
      expect(response).to render_template :index
    end
  end
end
