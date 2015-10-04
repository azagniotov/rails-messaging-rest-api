class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :started_by, :links

  def links
    {'self': "/api/v1/conversations/#{object.id}", 'all': '/api/v1/conversations'}
  end
end
