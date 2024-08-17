class EmailEnqueuerService
  def initialize(message, emails)
    @message = message
    @emails = emails

    unless @message.is_a?(Message)
      raise ArgumentError, "message must be Message model"
    end
  end

  def enqueue_jobs
    @emails.each do |email|
      SendEmailJob.perform_async(@message.id, email)
    end
  end
end
