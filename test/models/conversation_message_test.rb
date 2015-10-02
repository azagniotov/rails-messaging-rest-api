require 'test_helper'

class ConversationMessageTest < ActiveSupport::TestCase
  def setup
    @sender_id = 54321
    @conversation = Conversation.create(started_by: @sender_id)
    @message_one = Message.create(sender_id: @sender_id, text: 'Hello')
    @message_two = Message.create(sender_id: @sender_id, text: 'Good Bye')

    ConversationMessage.create(conversation: @conversation, message: @message_one)
    ConversationMessage.create(conversation: @conversation, message: @message_two)
  end

  def teardown
    Message.delete_all
    Conversation.delete_all
    ConversationMessage.delete_all
  end

  test 'message#1 should belong to only one conversation' do
    message = Message.find(@message_one.id)
    assert_not_nil message.conversation
    assert_equal @conversation.started_by, message.conversation.started_by
  end

  test 'conversation should have multiple messages' do
    conversation = Conversation.find(@conversation.id)
    assert_equal 2, conversation.messages.size
    assert_includes conversation.messages, @message_one
    assert_includes conversation.messages, @message_two
  end
end
