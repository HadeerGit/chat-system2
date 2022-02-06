require 'bunny'
require 'sneakers'

class Worker
  include Sneakers::Worker
  from_queue 'jobs',
             :env => 'development',
             :durable => true,
             :ack => true,
             :timeout_job_after => 1,
             :heartbeat => 5

  def work(msg)
    parsed_message = JSON.parse(msg)
    if parsed_message.key? "message"
      handle_message(parsed_message)
    elsif parsed_message.key? "chat"
      handle_chat(parsed_message)
    end
    ack!
  end

  def update_message(chat, message)
    msg = chat.messages.find_by(identifier: message["identifier"])
    msg.update(body: message["body"])
  end

  def create_message(chat, message)
    chat.messages.create!(body: message["body"], identifier: message["identifier"])
  end

  def handle_message(parsed_message)
    @chat = Chat.find_by(identifier: parsed_message["chat_identifier"])
    if parsed_message["type"] == "update"
      update_message(@chat, parsed_message)
    else
      create_message(@chat, parsed_message)
    end
  end

  def update_chat (application, chat)
    @chat = application.chats.find_by(identifier: chat["identifier"])
    @chat.update(name: chat["name"])
  end

  def create_chat(application, chat)
    application.chats.create!(name: chat["name"], identifier: chat["identifier"])
  end

  def handle_chat(parsed_message)
    @app = Application.find_by(token: parsed_message["token"])
    if parsed_message["action"] == "update"
      update_chat(@app, parsed_message["chat"])
    else
      create_chat(@app, parsed_message["chat"])
    end
  end
end