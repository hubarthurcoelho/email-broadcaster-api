class SendEmailJob
  include Sidekiq::Job

  def perform(msg_id, email)
    message = Message.find(msg_id)

    puts "Sending email to #{email} with title: #{message.title} and message: #{message.body}..."

    recipient = MessageRecipient.new(message: message, email: email, sent_at: Time.now)
    if recipient.save
      puts "Email sent to #{email} successfully."
    else
      puts "Error: #{msg.errors.full_messages.join(', ')}"
    end
  end
end
