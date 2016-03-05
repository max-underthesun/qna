require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #show' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }
    let(:comment) { create(:comment, commentable: question) }
    let(:user) { create(:user) }

    %w(Question Answer Comment User).each do |resource|
      let(:query) { resource == 'User' ? objects[resource].email : objects[resource].body }
      let(:scope) { resource.pluralize }
      let(:objects) do
        { 'Question' => question, 'Answer' => answer, 'Comment' => comment, 'User' => user }
      end

      describe "for any user with non-empty query to #{resource}: " do
        let(:search) { Search.new(scope: scope, query: query) }
        let(:params) do
          { query: query, scope: scope, format: "js", controller: "searches", action: "show" }
        end

        subject { get :show, query: query, scope: scope, format: :js }

        it "- expect to assigns a new valid instance of Search to @search" do
          subject
          expect(assigns(:search)).to be_a(Search)
          expect(assigns(:search)).to_not be_persisted
          expect(assigns(:search)).to be_valid
        end

        it "- expect Search.new to receive #search_with call" do
          allow(Search).to receive(:new).with(params).and_return(search)
          expect(search).to receive(:search_with)
          subject
        end

        it '- render show template' do
          subject
          expect(response).to render_template :show
        end
      end

      describe "for any user with empty query to #{resource}: " do
        let(:invalid_search) { Search.new(scope: scope, query: '') }
        let(:invalid_params) do
          { query: '', scope: scope, format: "js", controller: "searches", action: "show" }
        end

        subject { get :show, query: '', scope: scope, format: :js }

        it "- expect to assigns a new invalid instance of Search to @search" do
          subject
          expect(assigns(:search)).to be_a(Search)
          expect(assigns(:search)).to_not be_persisted
          expect(assigns(:search)).to_not be_valid
        end

        it "- expect Search.new to not receive #search_with call" do
          allow(Search).to receive(:new).with(invalid_params).and_return(invalid_search)
          expect(invalid_search).to_not receive(:search_with)
          subject
        end

        it '- render show template' do
          subject
          expect(response).to render_template :show
        end
      end
    end
  end
end
