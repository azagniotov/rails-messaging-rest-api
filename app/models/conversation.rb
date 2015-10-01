class Conversation < ActiveRecord::Base
  validates :started_by, presence: true
end
