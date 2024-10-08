class MessageReceiptsController < ApplicationController
  def index
    @message = Message.find(params[:message_id])
    @receipts = @message.message_receipts
    render json: @receipts
  end

  def create
    @message_receipt = MessageReceipt.create(message_receipt_params)
    if !@message_receipt.save
      render json: @message_receipt.errors, status: :unprocessable_entity
    end

    render json: @message_receipt, status: :created
  private
    def message_receipt_params
      params.require(:message_receipt).permit(:message, :address, :status)
    end
  end
end
