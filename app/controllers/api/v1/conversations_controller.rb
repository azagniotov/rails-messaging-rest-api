require 'uri'

class API::V1::ConversationsController < API::V1::BaseApiController

  def create
    Conversation.transaction do
      params = new_conversation_params
      if User.exists?(id: params[:started_by])
        conversation = Conversation.new(started_by: params[:started_by])
        if conversation.save
          ConversationUser.create(user: User.find(params[:started_by]), conversation: conversation)

          message = Message.new(sender_id: params[:started_by], text: params[:message])
          ConversationMessage.create(conversation: conversation, message: message)

          users = User.where(id: params[:recipient_ids])
          users.each { |user|
            ConversationUser.create(user: user, conversation: conversation)
          }
          render json: conversation, serializer: ConversationSerializer, status: 201
        end
      else
        render_error_as_json(400, 'Bad Request', "User with id '#{params[:started_by]}' does not exist")
      end
    end
  end

  def post_message
    conversation_id = URI(request.fullpath).path.split('/').last(2)[0]
    if Conversation.exists?(id: conversation_id)
      params = new_conversation_message_params
      if ConversationUser.exists?(conversation_id: conversation_id, user_id: params[:sender_id])
        message = Message.create(sender_id: params[:sender_id], text: params[:message])
        ConversationMessage.create(conversation: Conversation.find(conversation_id), message: message)
        render json: message, serializer: MessageSerializer, status: 201
      else
        render_error_as_json(400, 'Bad Request', "User with id '#{params[:sender_id]}' is not part of conversation id '#{conversation_id}'")
      end
    else
      render_error_as_json(400, 'Bad Request', "Conversation with id '#{conversation_id}' does not exist")
    end
  end

  def index
    render json: Conversation.all, each_serializer: ConversationSerializer
  end

  def show
    render json: Conversation.find(params[:conversation_id]), serializer: ConversationSerializer
  end

  def show_messages
    render json: Conversation.find(params[:conversation_id]), serializer: ConversationWithMessagesSerializer
  end

  def show_users
    render json: Conversation.find(params[:conversation_id]), serializer: ConversationWithUsersSerializer
  end

  private
  def new_conversation_params
    params.require(:conversation).require(:started_by)
    params.require(:conversation).require(:recipient_ids)
    params.require(:conversation).require(:message)
    params.require(:conversation).permit(:started_by, :message, :recipient_ids => [])
  end

  def new_conversation_message_params
    params.require(:conversation).require(:sender_id)
    params.require(:conversation).permit(:sender_id, :message)
  end

end
