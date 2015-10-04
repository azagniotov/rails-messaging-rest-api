class UserWithConversationsSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
  has_many :conversations

  def conversations
    object.conversations.as_json(
        only: [:id, :started_by]
    )
  end
end
