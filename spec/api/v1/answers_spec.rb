require 'rails_helper'

describe 'Answers API' do
  let!(:question) { create(:question) }
  let(:access_token) { create(:access_token) }

  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    # context 'unauthorized' do
    #   it "returns 'unauthorized' (401) status if there is no access_token" do
    #     get "/api/v1/questions/#{question.id}/answers", format: :json
    #     expect(response.status).to eq 401
    #   end

    #   it "returns 'unauthorized' (401) status if an access_token is not valid" do
    #     get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '1234'
    #     expect(response.status).to eq 401
    #   end
    # end

    context 'authorized' do
      let!(:answers) { create_list(:answer, 3, question: question) }
      let!(:answer) { answers.first }

      subject do
        get "/api/v1/questions/#{question.id}/answers",
            format: :json,
            access_token: access_token.token
      end

      before { subject }

      it "returns 'success' (200) status with valid access_token" do
        expect(response).to be_success
      end

      it "returns list of answers" do
        expect(response.body).to have_json_size(3).at_path("answers")
      end

      %w(body id user_id).each do |attr|
        it "contains #{attr}" do
          expect(response.body)
            .to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/2/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

  describe "GET /show" do
    let!(:answer) { create(:answer, question: question) }

    it_behaves_like "API Authenticable"

    # context 'unauthorized' do
    #   it "returns 'unauthorized' (401) status if there is no access_token" do
    #     get "/api/v1/answers/#{answer.id}", format: :json
    #     expect(response.status).to eq 401
    #   end

    #   it "returns 'unauthorized' (401) status if an access_token is not valid" do
    #     get "/api/v1/answers/#{answer.id}", format: :json, access_token: '1234'
    #     expect(response.status).to eq 401
    #   end
    # end

    context 'authorized' do
      let!(:comments) { create_list(:comment, 3, commentable: answer) }
      let(:comment) { comments.first }
      let!(:attachments) { create_list(:attachment, 3, attachable: answer) }
      let(:attachment) { attachments.first }

      subject do
        get "/api/v1/answers/#{answer.id}",
            format: :json,
            access_token: access_token.token
      end

      before { subject }

      it "returns 'success' (200) status with valid access_token" do
        expect(response).to be_success
      end

      it "returns one answer" do
        expect(response.body).to have_json_size(1)
      end

      %w(body id updated_at created_at user_id).each do |attr|
        it "contains #{attr}" do
          expect(response.body)
            .to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(3).at_path("answer/comments")
        end

        %w(body id user_id).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json)
              .at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(3).at_path("answer/attachments")
        end

        it "attachment object contains url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json)
            .at_path("answer/attachments/0/url")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", { format: :json }.merge(options)
    end
  end

  describe "POST /create" do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let!(:answer_attributes) { attributes_for(:answer, user: user) }

    it_behaves_like "API Authenticable"

    # context 'unauthorized' do
    #   it "returns 'unauthorized' (401) status if there is no access_token" do
    #     post "/api/v1/questions/#{question.id}/answers", answer: answer_attributes, format: :json
    #     expect(response.status).to eq 401
    #   end

    #   it "returns 'unauthorized' (401) status if an access_token is not valid" do
    #     post "/api/v1/questions/#{question.id}/answers",
    #          answer: answer_attributes, format: :json, access_token: '1234'
    #     expect(response.status).to eq 401
    #   end
    # end

    context 'authorized' do
      subject do
        post "/api/v1/questions/#{question.id}/answers",
             answer: answer_attributes,
             format: :json,
             access_token: access_token.token
      end

      it "returns 'success' (200) status with valid access_token" do
        subject
        expect(response).to be_success
      end

      context 'with valid attributes' do
        it 'adds a new answer for user' do
          expect { subject }.to change(user.answers, :count).by(1)
        end

        it 'adds a new answer for question' do
          expect { subject }.to change(question.answers, :count).by(1)
        end

        it "returns one answer in json" do
          subject
          expect(response.body).to have_json_size(1)
        end

        %w(body).each do |attr|
          it "returned json contains right #{attr}" do
            subject
            expect(response.body)
              .to be_json_eql(answer_attributes[attr.to_sym].to_json)
              .at_path("answer/#{attr}")
          end
        end
      end

      context 'with invalid attributes' do
        subject do
          post "/api/v1/questions/#{question.id}/answers",
               answer: attributes_for(:invalid_answer),
               format: :json,
               access_token: access_token.token
        end

        it 'does not save a new question to the database' do
          expect { subject }.to_not change(Answer, :count)
        end

        it 'returns 422 status' do
          subject
          expect(response.status).to eq 422
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers",
           { answer: answer_attributes, format: :json }.merge(options)
    end
  end
end
