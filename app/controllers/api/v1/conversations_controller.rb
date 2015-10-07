require 'uri'

class API::V1::ConversationsController < API::V1::BaseApiController

  def create
    Conversation.transaction do
      params = new_conversation_params
      conversation_service = ConversationService.new
      result = conversation_service.create_conversation(params[:started_by], params[:recipient_ids], params[:message])

      if result.instance_of? Conversation
        render json: result, serializer: ConversationSerializer, status: 201
      else
        render_error_as_json(result[:code], result[:message], result[:description])
      end
    end
  end

  def add_user
    conversation_id = extract_conversation_id_from_path
    params = new_conversation_user_params
    conversation_service = ConversationService.new
    result = conversation_service.add_user(conversation_id, params[:user_id])

    if result.instance_of? User
      render json: result, serializer: UserWithConversationsSerializer, status: 201
    else
      render_error_as_json(result[:code], result[:message], result[:description])
    end
  end

  def post_message
    conversation_id = extract_conversation_id_from_path
    if Conversation.exists?(id: conversation_id)
      params = new_conversation_message_params
      if ConversationUser.exists?(conversation_id: conversation_id, user_id: params[:sender_id])
        render json: create_conversation_message(conversation_id, params[:sender_id], params[:message]), serializer: MessageSerializer, status: 201
      else
        render_error_as_json(404, 'Not Found', "User with id '#{params[:sender_id]}' is not part of conversation id '#{conversation_id}'")
      end
    else
      render_error_as_json(404, 'Not Found', "Conversation with id '#{conversation_id}' does not exist")
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

  def new_conversation_user_params
    params.require(:conversation).require(:user_id)
    params.require(:conversation).permit(:user_id)
  end

  def extract_conversation_id_from_path
    path_chunks = URI(request.fullpath).path.split('/')
    last_path_chunks = path_chunks.last(2)
    last_path_chunks.first
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

