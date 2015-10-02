class Conversation < ActiveRecord::Base
  validates :started_by, presence: true

  has_many :conversation_users
  has_many :users, through: :conversation_users

  has_many :conversation_messages
  has_many :messages, through: :conversation_messages
end
