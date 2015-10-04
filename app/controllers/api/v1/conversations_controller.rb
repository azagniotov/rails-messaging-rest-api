class API::V1::ConversationsController < API::V1::BaseApiController

  def create
    Conversation.transaction do
      params = raw_conversation_params
      if User.exists?(id: params[:started_by])
        conversation = Conversation.new(started_by: params[:started_by])
        if conversation.save
          ConversationUser.create(user: User.find(params[:started_by]), conversation: conversation)

          message = Message.new(sender_id: params[:started_by], text: params[:text])
          ConversationMessage.create(conversation: conversation, message: message)

          users = User.where(id: params[:recipient_ids])
          users.each { |user|
            ConversationUser.create(user: user, conversation: conversation)
          }
          render json: conversation, serializer: ConversationSerializer, status: 201
        end
      else
        render :json => {
                   code: 400,
                   message: '400 Bad Request',
                   description: "User with id '#{params[:started_by]}' does not exist"
               }, :status => 400
      end
    end
  end

  def index
    render json: Conversation.all, each_serializer: ConversationSerializer
  end

  def show
    render json: Conversation.find(params[:conversation_id]), serializer: ConversationSerializer
  end

  def show_messages

  end

  def show_users
    render json: Conversation.find(params[:conversation_id]), serializer: ConversationWithUsersSerializer
  end

  private
  def raw_conversation_params
    params.require(:conversation).require(:started_by)
    params.require(:conversation).require(:recipient_ids)
    params.require(:conversation).require(:message)
    params.require(:conversation).permit(:started_by, :message, :recipient_ids => [])
  end

end
