require 'rails_helper'
require 'sendgrid-ruby'

RSpec.describe "Messages API", type: :request do
  let(:send_grid_mock_response) { double("response", status_code: "202", body: "success") }

  before do
    Sidekiq::Testing.inline!
    allow_any_instance_of(SendGrid::API).to receive_message_chain(:client, :mail, :_, :post)
      .and_return(send_grid_mock_response)
  end

  after do
    Sidekiq::Testing.fake!
  end

  describe "Message creation" do
    context "with valid params" do
      let(:valid_params) do
        {
          message: {
            title: "Test Title",
            body: "Test Body"
          },
          emails: [ "validemail@example.com", "another@example.com" ]
        }
      end

      it "creates a new message and message receipts for each provided email" do
        post '/messages', params: valid_params

        expect(response).to have_http_status(:created)
        expect(Message.count).to eq(1)
        expect(MessageReceipt.count).to eq(2)
      end

      it "lists the created message" do
        post '/messages', params: valid_params
        msg = Message.last

        get "/messages/#{msg.id}"
        body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(body).to be_a(Hash)
        expect(body).to include(
          "id" => msg.id,
          "title" => msg.title,
          "body" => msg.body
        )
      end

      it "lists message's receipts" do
        post '/messages', params: valid_params
        msg = Message.last

        get "/messages/#{msg.id}/message_receipts"
        body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(body).to be_a(Array)
        expect(body.size).to eq(2)
      end
    end

    context "with invalid params" do
      it "returns an error when message params are missing" do
        invalid_params = {
          message: {
            title: "Test Title"
          },
          emails: [ "validemail@example.com", "another@example.com" ]
        }

        post '/messages', params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns an error when emails are missing" do
        invalid_params = {
          message: {
            title: "Test Title",
            body: "Test Body"
          }
        }

        post '/messages', params: invalid_params

        expect(response).to have_http_status(:bad_request)
      end

      it "returns an error when emails are invalid" do
        invalid_params = {
          message: {
            title: "Test Title",
            body: "Test Body"
          },
          emails: [ "validemailexamplecom", "anotherexamplecom" ]
        }

        post '/messages', params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
