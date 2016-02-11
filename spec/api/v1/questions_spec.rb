require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it "returns 'unauthorized' (401) status if there is no access_token" do
        get "/api/v1/questions", format: :json
        expect(response.status).to eq 401
      end

      it "returns 'unauthorized' (401) status if an access_token is not valid" do
        get "/api/v1/questions", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      # let(:user) { create(:user) }
      let(:access_token) { create(:access_token) } # , resource_owner_id: user.id) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get "/api/v1/questions", format: :json, access_token: access_token.token }

      it "returns 'success' (200) status with valid access_token" do
        expect(response).to be_success
      end

      it "returns list of questions" do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(title body id updated_at created_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body)
            .to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it "question object contains short_title" do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json)
          .at_path("questions/0/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(body id updated_at created_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json)
              .at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe "GET /show" do
    context 'unauthorized' do
      it "returns 'unauthorized' (401) status if there is no access_token" do
        get "/api/v1/questions/show", format: :json
        expect(response.status).to eq 401
      end

      it "returns 'unauthorized' (401) status if an access_token is not valid" do
        get "/api/v1/questions/show", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      # let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:comments) { create_list(:comment, 3, commentable: question) }
      let(:comment) { comments.first }
      let!(:attachments) { create_list(:attachment, 3, attachable: question) }
      let(:attachment) { attachments.first }

      before do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token
      end

      it "returns 'success' (200) status with valid access_token" do
        expect(response).to be_success
      end

      it "returns one question" do
        expect(response.body).to have_json_size(1) # .at_path("question")
      end

      %w(title body id updated_at created_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body)
            .to be_json_eql(question.send(attr.to_sym).to_json).at_path("question_show/#{attr}")
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(3).at_path("question_show/comments")
        end

        %w(body id).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json)
              .at_path("question_show/comments/2/#{attr}")
          end
        end

        it "comment object contains user" do
          expect(response.body).to be_json_eql(comment.user.email.to_json)
            .at_path("question_show/comments/2/user")
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(3).at_path("question_show/attachments")
        end

        it "attachment object contains url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json)
            .at_path("question_show/attachments/2/url")
        end
      end
    end
  end

  describe "POST /create" do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let!(:question_attributes) { attributes_for(:question, user: user) }

    subject do
      post "/api/v1/questions",
           question: question_attributes,
           format: :json,
           access_token: access_token.token
    end

    context 'unauthorized' do
      it "returns 'unauthorized' (401) status if there is no access_token" do
        post "/api/v1/questions", question: question_attributes, format: :json
        expect(response.status).to eq 401
      end

      it "returns 'unauthorized' (401) status if an access_token is not valid" do
        post "/api/v1/questions", question: question_attributes,
                                  format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      # let!(:questions) { create_list(:question, 2) }
      # let(:question) { questions.first }
      # let!(:comments) { create_list(:comment, 3, commentable: question) }
      # let(:comment) { comments.first }
      # let!(:attachments) { create_list(:attachment, 3, attachable: question) }
      # let(:attachment) { attachments.first }

      # before do
      #   post "/api/v1/questions", format: :json, access_token: access_token.token
      # end

      it "returns 'success' (200) status with valid access_token" do
        subject
        # post "/api/v1/questions",
        #      question: attributes_for(:question, user: user),
        #      format: :json,
        #      access_token: access_token.token
        expect(response).to be_success
      end

      it 'saves a new question to the database' do
        expect { subject }.to change(user.questions, :count).by(1)

        # expect { post "/api/v1/questions",
        #               question: attributes_for(:question, user: user),
        #               format: :json, access_token: access_token.token
        # }.to change(user.questions, :count).by(1)
      end

      it "returns one question in json" do
        subject
        expect(response.body).to have_json_size(1) # .at_path("question")
      end

      %w(title body).each do |attr|
        it "returned json contains right #{attr}" do
          subject
          # puts question_params
          # puts response.body
          expect(response.body)
            .to be_json_eql(question_attributes[attr.to_sym].to_json)
            .at_path("question_show/#{attr}")
        end
      end

      # it 'redirect to show' do
      #   post :create, question: attributes_for(:question)
      #   expect(response).to redirect_to question_path(assigns(:question))
      # end
    end
  end
end
