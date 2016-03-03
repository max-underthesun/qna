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
end
