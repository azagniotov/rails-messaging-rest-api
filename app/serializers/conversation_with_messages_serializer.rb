class ConversationWithMessagesSerializer < ActiveModel::Serializer
  attributes :id, :started_by
  has_many :messages

  def messages
    object.messages.as_json(
        only: [:id, :sender_id, :text]
    )
  end
end
