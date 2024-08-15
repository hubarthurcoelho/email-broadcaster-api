class MessageRecipient < ApplicationRecord
  belongs_to :message

  validates :email, presence: true
  validates :sent_at, presence: true
  validates :email, uniqueness: { scope: :message_id }
end
