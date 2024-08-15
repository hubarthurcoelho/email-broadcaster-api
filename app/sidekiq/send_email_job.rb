class SendEmailJob
  include Sidekiq::Job

  # will go immediately to the Dead tab upon first failure
  sidekiq_options retry: 0

  def perform(msg_id, email)
    message = Message.find(msg_id)

    receipt = MessageReceipt.new(message: message, address: email, status: "PENDING")
    if !receipt.save
      puts "Error: #{receipt.errors.full_messages.join(', ')}"
      return
    end

    puts "Sending email to #{address} with title: #{message.title} and message: #{message.body}..."

    # Send email
    x = SendGrid.send_email(:address, :message.title, :message.body)

    if !x
      receipt.update(status: "FAILED")
    end

    receipt.update(status: "DELIVERED", delivered_at: Time.now)
  end
end
