require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let(:question_author) { create(:user) }
    let(:question) { create(:question, user: question_author) }
    let(:attachment) { create(:attachment, attachable: question) }

    describe 'for not signed in user: ' do
      before { attachment }

      it '- it should not delete the attachment from the database' do
        expect { delete :destroy, id: attachment, format: :js }
          .to_not change(Attachment, :count)
      end

      it '- should return 401 (unauthorized) status' do
        delete :destroy, id: attachment, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'for user signed in but not the author of the question:' do
      sign_in_user
      before { attachment }

      it '- it should not delete the attachment from the database' do
        expect { delete :destroy, id: attachment, format: :js }
          .to_not change(Attachment, :count)
      end

      it '- should return 403 (forbidden) status' do
        delete :destroy, id: attachment, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'for user signed in and author: ' do
      sign_in_user
      let(:question) { create(:question, user: @user) }
      let(:attachment) { create(:attachment, attachable: question) }
      before { attachment }

      it '- delete the attachment from the database' do
        expect { delete :destroy, id: attachment, format: :js }
          .to change(question.attachments, :count).by(-1)
      end

      it '- render destroy template' do
        delete :destroy, id: attachment, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
