class CreateMessageRecipients < ActiveRecord::Migration[7.2]
  def change
    create_table :message_recipients do |t|
      t.references :message, null: false, foreign_key: true
      t.string :email
      t.datetime :sent_at

      t.timestamps
    end
  end
end
