require 'uri'

class API::V1::ConversationsController < API::V1::BaseApiController

  def create
    params = new_conversation_params
    conversation_service = ConversationService.new
    result = conversation_service.create_conversation(params[:started_by], params[:recipient_ids], params[:message])

    render_response(result, Conversation, ConversationSerializer)
  end

  def add_user
    conversation_id = extract_conversation_id_from_path
    params = new_conversation_user_params
    conversation_service = ConversationService.new
    result = conversation_service.add_user(conversation_id, params[:user_id])

    render_response(result, User, UserWithConversationsSerializer)
  end

  def post_message
    conversation_id = extract_conversation_id_from_path
    params = new_conversation_message_params
    conversation_service = ConversationService.new
    result = conversation_service.post_message(conversation_id, params[:sender_id], params[:message])

    render_response(result, Message, MessageSerializer)
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

  def render_response(action_result, desired_class_type, serializer_class)
    if action_result.instance_of? desired_class_type
      render json: action_result, serializer: serializer_class, status: 201
    else
      render_error_as_json(action_result[:code], action_result[:message], action_result[:description])
    end
  end
end
