class SendEmailJob
  include Sidekiq::Job

  sidekiq_options retry: 0

  def perform(msg_id, address)
    message = find_message(msg_id)
    receipt = create_receipt(message, address)

    response = send_email(message, address)
    if response[:error]
      raise EmailDeliveryError, response[:error]
    end

    receipt.update(status: :DELIVERED, delivered_at: Time.current)

    rescue StandardError => e
      handle_error(e: e, receipt: receipt)
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
      email_sender = MailService.new
      email_sender.send(to_email: address, subject: message.title, content: message.body)
    end

    def handle_error (e:, receipt:)
      receipt&.update(status: :FAILED)
      Rails.logger.error(
        "SendEmailJob failed: msg_id #{receipt.message_id}; address: #{receipt.address}: #{e.message}"
      )
    end
end
