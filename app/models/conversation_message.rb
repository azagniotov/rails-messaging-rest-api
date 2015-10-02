class ConversationMessage < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :message

  validates_uniqueness_of :conversation_id, :scope => :message_id
end
