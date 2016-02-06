class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  respond_to :js
  # skip_authorization_check
  # authorize_resource

  def destroy
    @attachment = Attachment.find(params[:id])

    authorize! :destroy, @attachment
    respond_with @attachment.destroy

    # @attachment = Attachment.find(params[:id])
    # @attachable = @attachment.attachable
    # if current_user.author_of?(@attachable)
    #   @attachment.destroy && flash[:warning] = I18n.t('confirmations.attachment.destroy')
    # else
    #   flash[:alert] = I18n.t('failure.attachment.destroy')
    #   render status: :forbidden
    # end
  end
end
