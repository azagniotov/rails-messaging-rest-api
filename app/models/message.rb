class Message < ActiveRecord::Base
  validates :conversation_id, presence: true
  validates :sender_id, presence: true
end
