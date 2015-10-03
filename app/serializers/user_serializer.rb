class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :links

  def links
    { 'self': "/api/v1/users/#{object.id}" }
    { 'all': '/api/v1/users' }
  end
end
