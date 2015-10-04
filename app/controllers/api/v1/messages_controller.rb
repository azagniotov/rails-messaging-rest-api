class API::V1::MessagesController < API::V1::BaseApiController
  def show
    render json: Message.find(params[:message_id]), serializer: MessageSerializer
  end
end
