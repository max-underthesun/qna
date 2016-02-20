shared_examples_for "PrivatePub Publishable" do
  it 'should publish resource after create' do
    # allow(Question).to receive(:create).and_return(question)
    # Question.any_instance.stub(:to_json).and_return(question.to_json)
    allow_any_instance_of(resource_klass).to receive(:to_json).and_return(resource.to_json)
    # allow_any_instance_of(Question).to receive(:to_json).and_return(question.to_json)
    expect(PrivatePub).to receive(:publish_to).with(channel, args)
    # expect(PrivatePub).to receive(:publish_to).with(channel, anything)
    subject
  end
end
