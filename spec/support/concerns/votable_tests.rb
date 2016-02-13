# require 'rails_helper'

RSpec.shared_examples "votable" do
  let(:model) { described_class }
  let(:user) { create(:user) }

  it { should have_many(:votes).dependent(:destroy) }

  before { @resource = create(model.to_s.underscore.to_sym, user: user) }

  it "has a #rating" do
    expect(@resource.rating).to eq 0

    create :vote, votable: @resource
    expect(@resource.rating).to eq 1
  end
end
