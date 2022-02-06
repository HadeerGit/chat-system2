require 'bunny'
require 'sneakers'

class Worker
  include Sneakers::Worker
  from_queue 'jobs',
             :env => 'development',
             :durable => true ,
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


  def edit_message(chat, parsed_message)
    message = chat.messages.find_by(identifier: parsed_message["message"]["number"])
    message.update(body: parsed_message["message"]["body"])
  end

  def create_message(application, parsed_message)
    # Create the chat using ActiveRecord_Relation
    if (@chat = application.chats.create(name: parsed_message["message"]["name"]))
      logger.info { 'Chat has been created successfully'}
    else
      logger.info { 'Could not save the chat. Please try again later'}
    end
  end

  def handle_message(parsed_message)
    @app = Application.find_by(token: parsed_message["token"])
    if parsed_message["type"] == "update"
      update_message(@app, parsed_message)
    else
      create_message(@app, parsed_message)
    end
  end

  def update_chat (application, chat)
    @chat = application.chats.find_by(identifier: chat["identifier"])
    @chat.update(name: chat["name"])
  end

  def create_chat(application, chat)
    application.chats.create!(name: chat["name"], identifier: chat["identifier"])
    # increment_application_chat_count(application)
  end

  def handle_chat(parsed_message)
    @app = Application.find_by(token: parsed_message["token"])
    logger.error { 'StepWorker received params: ' + parsed_message["action"]  }

    if parsed_message["action"] == "update"
      logger.error { 'StepWorker received params: ' + parsed_message["action"]  }
      update_chat(@app, parsed_message["chat"])
    else
      create_chat(@app, parsed_message["chat"])
    end
  end

  private

  # def increment_application_chat_count(application)
  #   application.chat_count += 1
  #   application.save
  # end
  #
  # def increment_chat_message_count(chat)
  #   chat.message_count += 1
  #   chat.save
  # end
end