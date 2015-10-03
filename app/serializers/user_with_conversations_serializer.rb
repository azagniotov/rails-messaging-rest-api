class UserWithConversationsSerializer < ActiveModel::Serializer
  attributes :id, :links
  has_many :conversations
  def links
    { 'self': "/api/v1/users/#{object.id}/conversations" }
  end
end
