require 'rails_helper'

RSpec.describe Search, type: :model do
  it "validates presence of query" do
    expect(Search.new(scope: Search::RESOURCES.keys.sample)).to_not be_valid
  end

  it "validates presence of scope" do
    expect(Search.new(query: 'abba')).to_not be_valid
  end

  it "validates inclusion of scope it to the 'RESOURCES' list" do
    expect(Search.new(scope: Search::RESOURCES.keys.sample, query: 'abba')).to be_valid

    expect(Search.new(scope: 'Votes', query: 'abba')).to_not be_valid
  end

  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:comment) { create(:comment, commentable: question) }
  let(:user) { create(:user) }

  %w(Question Answer Comment User).each do |resource|
    describe "call #search_with for Search.new(scope: #{resource.pluralize}, query: query): " do
      let(:objects) do
        { 'Question' => question, 'Answer' => answer, 'Comment' => comment, 'User' => user }
      end
      let(:query) { resource == 'User' ? objects[resource].email : objects[resource].body }

      let(:search) { Search.new(scope: resource.pluralize, query: query) }
      let(:params) { { page: 1, per_page: 5 } }

      subject { search.search_with(params) }

      it "- expect #{resource} to receive call for .search with (Riddle.escape(query), params)" do
        expect(resource.constantize).to receive(:search).with(Riddle.escape(query), anything)
        subject
      end
    end
  end

  %w(Question Answer Comment User).each do |resource|
    describe "call #search_with for Search.new(scope: 'Everywhere', query: query): " do
      let(:objects) do
        { 'Question' => question, 'Answer' => answer, 'Comment' => comment, 'User' => user }
      end
      let(:query) { resource == 'User' ? objects[resource].email : objects[resource].body }

      let(:search) { Search.new(scope: 'Everywhere', query: query) }
      let(:params) { { page: 1, per_page: 5 } }

      subject { search.search_with(params) }

      it "- expect ThinkingSphinx to receive call for .search with (Riddle.escape(query), params)" do
        expect(ThinkingSphinx).to receive(:search).with(Riddle.escape(query), anything)
        subject
      end
    end
  end
end
