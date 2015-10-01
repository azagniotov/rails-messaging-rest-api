require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  def setup
    @started_by = 12345
  end

  def teardown
    Conversation.delete_all
  end

  test 'should save new conversation to DB when all required properties are set' do
    conversation = Conversation.new(started_by: @started_by)
    assert conversation.save
  end

  test 'should not save new conversation to DB when started_by is not set' do
    conversation = Conversation.new
    assert_not conversation.save
  end
end
