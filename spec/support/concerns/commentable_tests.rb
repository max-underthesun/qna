RSpec.shared_examples "commentable" do
  let(:model) { described_class }
  let(:user) { create(:user) }

  it { should have_many(:comments).dependent(:destroy) }

  before { @resource = create(model.to_s.underscore.to_sym, user: user) }
end
