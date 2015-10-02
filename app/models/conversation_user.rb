class ConversationUser < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :user

  validates_uniqueness_of :conversation_id, :scope => :user_id
end
