shared_examples_for "updatable resource" do
  describe 'for not signed in user: ' do
    it "- should not update resource" do
      original_resource = resource
      request
      expect(resource.reload).to eq original_resource
    end

    it '- should return 401 (unauthorized) status' do
      request
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'for user signed in but not the author: ' do
    sign_in_user

    it "- should not update resource" do
      original_resource = resource
      request
      expect(resource.reload).to eq original_resource
    end

    it '- should return 403 (forbidden) status' do
      request
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'for user signed in and author: ' do
    sign_in_user

    context 'with valid attributes' do
      let(:resource) { create(resource_name.to_sym, user: @user) }

      it "- assigns resource to @resource" do
        request
        expect(assigns(resource_name.to_sym)).to eq resource
      end

      it "- change the resource attributes" do
        request
        resource.reload
        resource_attributes.each do |attribute|
          expect(assigns(resource_name.to_sym).send(attribute.to_sym))
            .to eq updated_resource.send(attribute.to_sym)
        end
      end

      it "- render resource update template" do
        request
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it '- should not update resource' do
        original_resource = resource
        request_with_invalid_attributes
        expect(assigns(resource_name.to_sym)).to eq original_resource
      end

      it '- render resource update template' do
        request_with_invalid_attributes
        expect(response).to render_template :update
      end
    end
  end
end
