require "sendgrid-ruby"

module Providers
  class SendGrid < EmailSender
    include SendGrid

    def initialize(api_key: ENV["SENDGRID_API_KEY"], domain: ENV["SENDGRID_DOMAIN"])
      @api = SendGrid::API.new(api_key: api_key)
      @sender = domain
    end

    def send(to_email:, subject:, content:)
      to = Email.new(email: to_email)
      from = Email.new(email: @sender)
      content = build_content(content: content)

      mail = build_mail(from: from, to: to, subject: subject, content: content)

      send_email(mail: mail)
    end

    private

    def build_content(content:)
      Content.new(type: "text/plain", value: content)
    end

    def build_mail(from:, to:, subject:, content:)
      Mail.new(from, subject, to, content)
    end

    def send_email(mail:)
      @api.client.mail._("send").post(request_body: mail.to_json)
    end
  end
end
