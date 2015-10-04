class ConversationsRoutesTest < ActionController::TestCase
  test 'should route to all conversation' do
    assert_routing '/api/v1/conversations', {format: 'json', controller: 'api/v1/conversations', action: 'index'}
  end

  test 'should route to conversation by id' do
    assert_routing '/api/v1/conversations/1', {format: 'json', controller: 'api/v1/conversations', action: 'show', conversation_id: '1'}
  end

  test 'should route to conversation messages by conversation id' do
    assert_routing '/api/v1/conversations/1/messages', {format: 'json', controller: 'api/v1/conversations', action: 'show_messages', conversation_id: '1'}
  end

  test 'should route to conversation users by conversation id' do
    assert_routing '/api/v1/conversations/1/users', {format: 'json', controller: 'api/v1/conversations', action: 'show_users', conversation_id: '1'}
  end

  test 'should route to create conversation' do
    assert_routing({method: 'post', path: '/api/v1/conversations'}, {format: 'json', controller: 'api/v1/conversations', action: 'create'})
  end
end