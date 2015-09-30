class UserSerializer < ActiveModel::Serializer

  attributes :id, :name, :email, :auth_token, :links

  def links
    { 'self': "/api/v1/users/#{object.id}" }
  end
end
