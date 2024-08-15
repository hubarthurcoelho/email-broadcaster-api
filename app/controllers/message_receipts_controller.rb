class MessageReceiptsController < ApplicationController
  def create
    @message_receipt = MessageReceipt.create(message_receipt_params)
    if @message_receipt.save
      render json: @message_receipt, status: :created
    else
      render json: @message_receipt.errors, status: :unprocessable_entity
    end
  private
    def message_receipt_params
      params.require(:message_receipt).permit(:message, :address, :status)
    end
  end
end
