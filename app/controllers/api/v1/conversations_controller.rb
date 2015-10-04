class API::V1::ConversationsController < API::V1::BaseApiController

  def create
    Conversation.transaction do
      params = raw_conversation_params
      if User.exists?(id: params[:started_by])
      conversation = Conversation.new(started_by: params[:started_by])
        if conversation.save
          ConversationUser.create(user: User.find(params[:started_by]), conversation: conversation)
          users = User.where(id: params[:recipient_ids])
          users.each { |user|
            ConversationUser.create(user: user, conversation: conversation)
          }
          render json: conversation, serializer: ConversationSerializer, status: 201
        end
      end
    end
  end

  def index

  end

  def show

  end

  def show_messages

  end

  def show_users

  end

  private
  def raw_conversation_params
    params.require(:conversation).require(:started_by)
    params.require(:conversation).require(:recipient_ids)
    #params.require(:conversation).require(:message)
    params.require(:conversation).permit(:started_by, :recipient_ids => [])
  end

end
