class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachable = @attachment.attachable
    if current_user.author_of?(@attachable)
      @attachment.destroy && flash[:warning] = I18n.t('confirmations.attachment.destroy')
    else
      flash[:alert] = I18n.t('failure.attachment.destroy')
      render status: :forbidden
    end
  end
end