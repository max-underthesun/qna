shared_examples_for "PrivatePub Publishable" do
  it 'should publish resource after create' do
    expect(PrivatePub).to receive(:publish_to).with(channel, anything)
    subject
  end
end