class ConversationWithUsersSerializer < ActiveModel::Serializer
  attributes :id, :started_by
  has_many :users

  def users
    object.users.as_json(
        only: [:id, :name, :email]
    )
  end
end
