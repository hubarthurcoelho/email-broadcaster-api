class Message < ApplicationRecord
  has_many :message_recipients

  validates :title, presence: false, length: { maximum: 50 }
  validates :body, presence: true, length: { maximum: 500 }
end
