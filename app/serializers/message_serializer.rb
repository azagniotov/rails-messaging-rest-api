class MessageSerializer < ActiveModel::Serializer
  attributes :id, :sender_id, :text, :created_at, :links

  def links
    {'self': "/api/v1/messages/#{object.id}"}
  end
end
