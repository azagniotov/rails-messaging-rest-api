class Conversation < ActiveRecord::Base
  validates :started_by, presence: true

  has_many :conversation_users
  has_many :users, through: :conversation_users
end
