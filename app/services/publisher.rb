module PUBLISHER
  def self.publish(msg)
    # Start a communication session with RabbitMQ
    connection = Bunny.new(hostname: "rabbitmq:5672")
    connection.start

    # open a channel
    channel = connection.create_channel

    # declare a queue
    queue  = channel.queue("jobs", :durable => true)

    # publish a message to the default exchange which then gets routed to this queue
    puts "DDDD"
    queue.publish(msg.to_json)
    puts "after"
    connection.close
  end
end