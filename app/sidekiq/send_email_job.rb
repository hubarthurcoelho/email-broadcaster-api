class SendEmailJob
  include Sidekiq::Job

  def initialize(mailService: MailService.new)
    @mail_service = mailService
  end

  sidekiq_options retry: 0

  def perform(msg_id, address)
    message = find_message(msg_id)
    receipt = create_receipt(message, address)

    res = @mail_service.send(to_email: address, subject: message.title, content: message.body)
    if res[:error]
      raise EmailDeliveryError, res[:error]
    end

    receipt.update(status: :DELIVERED, delivered_at: Time.current)

    rescue StandardError => e
      receipt&.update(status: :FAILED)
      Rails.logger.error(build_err_msg(e: e, receipt: receipt))
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

    def build_err_msg (e:, receipt:)
      "SendEmailJob failed: msg_id #{receipt.message_id}; address: #{receipt.address}: #{e.message}"
    end
end
