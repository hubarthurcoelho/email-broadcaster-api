require "rails_helper"

RSpec.describe MailService, type: :service do
  let(:mock_client) { instance_double("SendGridClient") }

  describe "#initialize" do
    it "initializes with a valid mail client" do
      expect { MailService.new(mock_client) }.not_to raise_error
    end

    it "raises an error when the client does not include MailClient" do
      allow(mock_client).to receive(:is_a?).with(MailClient).and_return(false)

      expect { MailService.new(mock_client) }.to raise_error(ArgumentError, "client must include MailClient module")
    end
  end

  describe "#send" do
    let(:mail_service) { MailService.new(mock_client) }

    it "calls the send method on the provider with the correct arguments" do
      to_email = "example@example.com"
      subject = "Hello"
      content = "This is the email content."

      expect(mock_client).to receive(:send).with(to_email: to_email, subject: subject, content: content)

      mail_service.send(to_email: to_email, subject: subject, content: content)
    end
  end
end
