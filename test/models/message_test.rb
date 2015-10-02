require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup
    @conversation_id = 12345
    @sender_id = 54321
    @text = 'You know it..'
  end

  def teardown
    Message.delete_all
  end

  test 'should save new message to DB when all required properties are set' do
    message = Message.new(conversation_id: @conversation_id, sender_id: @sender_id, text: @text)
    assert message.save
  end

  test 'should not save new message to DB when sender_id is not set' do
    message = Message.new(conversation_id: @conversation_id, text: @text)
    assert_not message.save
  end

  test 'should not save new message to DB when conversation_id is not set' do
    message = Message.new(sender_id: @sender_id, text: @text)
    assert_not message.save
  end

  test 'should get message text from DB' do
    message = Message.create(conversation_id: @conversation_id, sender_id: @sender_id, text: @text)
    db_message = Message.find(message.id)

    assert_equal @text, db_message.text
  end
end
