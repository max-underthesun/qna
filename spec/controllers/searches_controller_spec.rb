require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #show' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }
    let(:comment) { create(:comment, commentable: question) }
    let(:user) { create(:user) }

    %w(Question Answer Comment User).each do |resource|
      describe "for any user with non-empty query to #{resource}: " do
        let(:objects) do
          { 'Question' => question, 'Answer' => answer, 'Comment' => comment, 'User' => user }
        end
        let(:query) { resource == 'User' ? objects[resource].email : objects[resource].body }

        subject { get :show, query: query, resource: resource, format: :js }

        it "- expect #{resource} to receive call for 'search'" do
          expect(resource.constantize).to receive(:search).with(Riddle.escape(query), anything)
          subject
        end

        it '- render show template' do
          subject
          expect(response).to render_template :show
        end
      end

      describe "for any user with empty query to #{resource}: " do
        subject { get :show, query: '', resource: resource, format: :js }

        it "- expect #{resource} to NOT receive call for 'search'" do
          expect(resource.constantize).to_not receive(:search)
          subject
        end

        it '- redirect to root path' do
          subject
          expect(response).to redirect_to :root
        end
      end
    end
  end
end
