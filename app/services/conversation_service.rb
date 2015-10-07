class ConversationService

  def create_conversation(started_by, recipient_ids, message)
    if User.exists?(id: started_by)
      conversation = Conversation.create(started_by: started_by)
      create_conversation_users(conversation, recipient_ids << started_by)
      create_conversation_message(conversation, started_by, message)

      conversation
    else
      {code: 404, message: 'Not Found', description: "User with id '#{started_by}' does not exist"}
    end
  end


  def add_user(conversation_id, user_id)
    if Conversation.exists?(id: conversation_id)
      if ConversationUser.exists?(conversation_id: conversation_id, user_id: user_id)
        {code: 409, message: 'Conflict', description: "User with id '#{user_id}' is already part of conversation id '#{conversation_id}'"}
      else
        if User.exists?(id: user_id)
          user = User.find(user_id)
          ConversationUser.create(user: user, conversation: Conversation.find(conversation_id))

          user
        else
          {code: 404, message: 'Not Found', description: "User with id '#{user_id}' does not exist"}
        end
      end
    else
      {code: 404, message: 'Not Found', description: "Conversation with id '#{conversation_id}' does not exist"}
    end
  end

  def post_message(conversation_id, sender_id, message)
    if Conversation.exists?(id: conversation_id)
      if ConversationUser.exists?(conversation_id: conversation_id, user_id: sender_id)
        create_conversation_message(conversation_id, sender_id, message)
      else
        {code: 404, message: 'Not Found', description: "User with id '#{sender_id}' is not part of conversation id '#{conversation_id}'"}
      end
    else
      {code: 404, message: 'Not Found', description: "Conversation with id '#{conversation_id}' does not exist"}
    end
  end

  private

  def create_conversation_users(conversation, user_ids)
    users = User.where(id: user_ids)
    users.each { |user|
      ConversationUser.create(user: user, conversation: conversation)
    }
  end

  def create_conversation_message(conversation, sender_id, text)
    message = Message.new(sender_id: sender_id, text: text)

    if conversation.instance_of? Conversation
      ConversationMessage.create(conversation: conversation, message: message)
    elsif conversation.instance_of? String
      ConversationMessage.create(conversation: Conversation.find(conversation), message: message)
    end
    message
  end
end
