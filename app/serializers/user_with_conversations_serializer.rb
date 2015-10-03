class UserWithConversationsSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
  has_many :conversations
end
