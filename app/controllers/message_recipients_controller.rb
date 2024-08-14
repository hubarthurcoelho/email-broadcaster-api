class MessageRecipientsController < ApplicationController
  def create
    @message_recipient = MessageRecipient.create(email: message_recipient_params[:email], sent_at: Time.now)

    if @message_recipient.save
      render json: @message_recipient, status: :created
    else
      render json: @message_recipient.errors, status: :unprocessable_entity
    end

  private
    def message_recipient_params
      params.require(:message_recipient).permit(:email)
    end
  end
end
