class MessagesController < ApplicationController
  def index
    @messages = Message.all
    render json: @messages
  end

  def show
    @message = Message.includes(:message_receipts).find(params[:id])
    render json: @message.as_json(
      only: [ :id, :title, :body ],
      include: {
        message_receipts: {
          only: [ :address, :status, :delivered_at ]
        }
      }
    )
  end

  def create
    @message = Message.new(message_params)

    if !@message.save
      render json: @message.errors, status: :unprocessable_entity
    end

    if params[:emails].present?
      params[:emails].each do |email|
        SendEmailJob.perform_async(@message.id, email)
      end
    end

    render json: @message, status: :created
  end

  private
    def message_params
      params.require(:message).permit(:body, :title)
    end
end
