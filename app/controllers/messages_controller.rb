class MessagesController < ApplicationController
  def index
    @messages = Message.all
    render json: @messages
  end

  def show
    @message = Message.includes(:message_recipients).find(params[:id])
    render json: @message.as_json(only: [ :body, :title ], include: { message_recipients: { only: [ :email ] } })
  end

  def create
    @message = Message.new(message_params)

    if @message.save
      render json: @message, status: :created

      if params[:emails].present?
        params[:emails].each do |email|
          @message.message_recipients.create(email: email, sent_at: Time.now)
        end
      end
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private
    def message_params
      params.require(:message).permit(:body, :title)
    end
end
