class Message < ActiveRecord::Base
  validates :sender_id, presence: true

  has_one :conversation_message
  has_one :conversation, :through => :conversation_message
end
