require "rails_helper"
require "sendgrid-ruby"

RSpec.describe SendGridClient do
  let(:api_key) { "test_api_key" }
  let(:domain) { "test@example.com" }
  let(:sendgrid_client) { SendGridClient.new(api_key: api_key, domain: domain) }

  describe '#initialize' do
    it 'initializes with the correct API key and sender domain' do
      expect(sendgrid_client.instance_variable_get(:@api)).to be_a(SendGrid::API)
      expect(sendgrid_client.instance_variable_get(:@sender)).to eq(domain)
    end
  end

  describe '#send' do
    let(:to_email) { "recipient@example.com" }
    let(:subject) { "Test Subject" }
    let(:content) { "This is a test email." }
    let(:mock_response) { double("response", status_code: "202", body: "success") }

    before do
      allow_any_instance_of(SendGrid::API).to receive_message_chain(:client, :mail, :_, :post)
      .and_return(mock_response)
    end

    it 'sends an email with the correct parameters' do
      response = sendgrid_client.send(to_email: to_email, subject: subject, content: content)
      expect(response[:body]).to eq("success")
      expect(response[:error]).to be_nil
    end

    context 'when an unknown error occurs' do
      before do
        allow_any_instance_of(SendGrid::API).to receive_message_chain(:client, :mail, :_, :post)
          .and_raise(StandardError, "An error occurred")
      end
      it 'returns an error message' do
        response = sendgrid_client.send(to_email: to_email, subject: subject, content: content)
        expect(response[:body]).to be_nil
        expect(response[:error]).not_to be_nil
      end
    end

    context 'when an API error occurs' do
      let(:err_mock_response) { double("response", status_code: "400", body: "wrong email format") }
      before do
        allow_any_instance_of(SendGrid::API).to receive_message_chain(:client, :mail, :_, :post)
          .and_return(err_mock_response)
      end

      it 'returns an error message' do
        response = sendgrid_client.send(to_email: to_email, subject: subject, content: content)
        expect(response[:body]).to be_nil
        expect(response[:error]).not_to be_nil
      end
    end
  end
end
