require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    let(:question_author) { create(:user) }
    let(:question) { create(:question, user: question_author) }
    let(:subscription) { create(:subscription, question: question) }

    subject do
      post :create, question_id: question, subscription: attributes_for(:subscription), format: :js
    end

    describe 'for not signed in user: ' do
      it '- it should not add a subscription to the database' do
        expect { subject }.to_not change(Subscription, :count)
      end

      it '- should return 401 (unauthorized) status' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'for user signed in and author of the question: ' do
      sign_in_user

      let(:question) { create(:question, user: @user) }

      it '- add a subscription to the question subscriptions' do
        expect { subject }.to_not change(Subscription, :count)
      end

      it '- should return 403 (forbidden) status' do
        subject
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'for user signed in and not an author of the question: ' do
      sign_in_user

      it '- add a subscription to the question subscriptions' do
        expect { subject }.to change(question.subscriptions, :count).by(1)
        expect(assigns(:subscription).user).to eq @user
      end

      it '- render create template' do
        subject
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:subscriber) { create(:user) }
    let(:question_author) { create(:user) }
    let(:question) { create(:question, user: question_author) }
    let(:subscription) { create(:subscription, question: question, user: subscriber) }

    subject { delete :destroy, id: subscription, format: :js }

    describe 'for not signed in user: ' do
      before { subscription }

      it '- it should not add a subscription to the database' do
        expect { subject }.to_not change(Subscription, :count)
      end

      it '- should return 401 (unauthorized) status' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'for user signed in but not the author of subscription:' do
      sign_in_user
      before { subscription }

      it '- it should not delete the subscription from the database' do
        expect { subject }.to_not change(Subscription, :count)
      end

      it '- should return 403 (forbidden) status' do
        subject
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'for user signed in and author of subscription: ' do
      sign_in_user
      let(:subscription) { create(:subscription, question: question, user: @user) }
      before { subscription }

      it '- remove a subscription from the question subscriptions' do
        expect { subject }.to change(question.subscriptions, :count).by(-1)
      end

      it '- render destroy template' do
        subject
        expect(response).to render_template :destroy
      end
    end
  end
end
