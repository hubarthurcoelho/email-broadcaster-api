class EmailSenderJob
  include Sidekiq::Job

  def perform(title, body)
    puts "#{title}: #{body}"
  end
end
