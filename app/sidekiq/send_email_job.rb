class SendEmailJob
  include Sidekiq::Job
  # will go immediately to the Dead tab upon first failure
  sidekiq_options retry: 0

  def perform(msg_id, address)
    message = Message.find(msg_id)

    receipt = MessageReceipt.new(message: message, address: address, status: "PENDING")
    if !receipt.save
      puts "Error: #{receipt.errors.full_messages.join(', ')}"
      return
    end

    sg = Providers::SendGrid.initialize(api_key: ENV["SENDGRID_API_KEY"], domain: ENV["SENDGRID_DOMAIN"])

    response = Services::Email.initialize(email_sender_provider: sg).send(
      to_email: address,
      subject: message.title,
      content: message.body
    )

    puts response

    receipt.update(status: "DELIVERED", delivered_at: Time.now)
    puts "Delivered email to #{email}"
  end
end
