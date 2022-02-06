class QueueWorker
  include Sidekiq::Worker

  def perform(chat)
    puts "kkkk"
  end
end
