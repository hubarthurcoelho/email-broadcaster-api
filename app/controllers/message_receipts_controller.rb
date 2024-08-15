class MessageReceiptsController < ApplicationController
  def create
    @message_receipt = MessageReceipt.create(message_receipt_params)
    if @message_recipient.save
      render json: @message_recipient, status: :created
    else
      render json: @message_recipient.errors, status: :unprocessable_entity
    end
  private
    def message_receipt_params
      params.require(:message_receipt).permit(:message, :recipient, :status, :delivered_at)
    end
  end
end
