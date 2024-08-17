class MessagesController < ApplicationController
  def index
    @messages = Message.all
    render json: @messages
  end

  def show
    @message = Message.find(params[:id])
    render json: @message
  end

  def create
    @message = Message.new(message_params)

    if !@message.save
      return render json: @message.errors, status: :unprocessable_entity
    end

    emails = emails_params[:emails]
    if !emails.present?
      return render json: @message, status: :created
    end

    errs = EmailValidatorService.new.validate_multiple(emails)
    if errs.any?
      return render json: errs, status: :unprocessable_entity
    end

    EmailEnqueuerService.new(@message, emails).enqueue_jobs
    render json: @message, status: :created
  end

  private
    def message_params
      params.require(:message).permit(:body, :title)
    end

    def emails_params
      params.permit(emails: [])
    end
end
