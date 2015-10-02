require 'test_helper'

class ConversationUserTest < ActiveSupport::TestCase
  def setup
    @user_one = User.create(name: 'Alex-1', email: '11111@gmail.com', password: '12345')
    @user_two = User.create(name: 'Alex-2', email: '22222@gmail.com', password: '54321')
    @conversation_one = Conversation.create(started_by: @user_one.id)
    @conversation_two = Conversation.create(started_by: @user_one.id)

    ConversationUser.create(user: @user_one, conversation: @conversation_one)
    ConversationUser.create(user: @user_two, conversation: @conversation_one)
    ConversationUser.create(user: @user_one, conversation: @conversation_two)
  end

  def teardown
    User.delete_all
    Conversation.delete_all
    ConversationUser.delete_all
  end

  test 'user#1 should be a participant in two conversations' do
    user = User.find(@user_one.id)
    assert_equal 2, user.conversations.size
    assert_includes user.conversations, @conversation_one
    assert_includes user.conversations, @conversation_two
  end

  test 'user#2 should be a participant in one conversation' do
    user = User.find(@user_two.id)
    assert_equal 1, user.conversations.size
    assert_equal @conversation_one.id, user.conversations[0].id
  end

  test 'conversation#1 should have two participants' do
    conversation = Conversation.find(@conversation_one.id)
    assert_equal 2, conversation.users.size
    assert_includes conversation.users, @user_one
    assert_includes conversation.users, @user_two
  end

  test 'conversation#2 should have one participant' do
    conversation = Conversation.find(@conversation_two.id)
    assert_equal 1, conversation.users.size
    assert_equal @user_one.id, conversation.users[0].id
  end
end
