class SendEmailJob
  include Sidekiq::Job
  # require "sendgrid-ruby"
  # include SendGrid

  # will go immediately to the Dead tab upon first failure
  sidekiq_options retry: 0

  def perform(msg_id, email)
    message = Message.find(msg_id)

    receipt = MessageReceipt.new(message: message, address: email, status: "PENDING")
    if !receipt.save
      puts "Error: #{receipt.errors.full_messages.join(', ')}"
      return
    end

    # using SendGrid's Ruby Library
    # https://github.com/sendgrid/sendgrid-ruby
    # from = Email.new(email: "test@example.com")
    # to = Email.new(email: "test@example.com")
    # subject = "Sending with SendGrid is Fun"
    # content = Content.new(type: "text/plain", value: "and easy to do anywhere, even with Ruby")
    # mail = Mail.new(from, subject, to, content)

    # sg = SendGrid::API.new(api_key: ENV["SENDGRID_API_KEY"])
    # response = sg.client.mail._("send").post(request_body: mail.to_json)
    # puts response.status_code
    # puts response.body
    # puts response.headers

    receipt.update(status: "DELIVERED", delivered_at: Time.now)
    puts "Delivered email to #{email}"
  end
end
