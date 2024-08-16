class SendEmailJob
  include Sidekiq::Job

  sidekiq_options retry: 0

  def perform(msg_id, address)
    Rails.logger.info("SendEmailJob initiated: msg_id #{msg_id}; address: #{address}")

    message = find_message(msg_id)
    receipt = create_receipt(message, address)

    response = send_email(message, address)
    if !response[:error].nil?
      raise EmailDeliveryError, response[:error]
    end

    receipt.update(status: :DELIVERED, delivered_at: Time.current)

    Rails.logger.info("SendEmailJob finished: msg_id #{msg_id}; address: #{address}")
    rescue StandardError => e
      receipt&.update(status: :FAILED)
      Rails.logger.error("SendEmailJob failed: msg_id #{msg_id}; address: #{address}: #{e.message}")
  end

  private
    def find_message(msg_id)
      Message.find(msg_id)
    end

    def create_receipt(message, address)
      receipt = MessageReceipt.new(message: message, address: address, status: :PENDING)
      receipt.save!
      receipt
    end

    def send_email(message, address)
      email_sender = build_email_sender
      email_sender.send(to_email: address, subject: message.title, content: message.body)
    end

    def build_email_sender
      sendgrid_provider = SendGridClient.new
      MailService.new(client: sendgrid_provider)
    end
end
