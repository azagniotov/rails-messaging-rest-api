class UsersRoutesTest < ActionController::TestCase
  test 'should route to user by id' do
    assert_routing '/api/v1/users/1', { format: 'json', controller: 'api/v1/users', action: 'show', user_id: '1' }
  end

  test 'should route to user conversations by user id' do
    assert_routing '/api/v1/users/1/conversations', { format: 'json', controller: 'api/v1/users', action: 'show_conversations', user_id: '1' }
  end

  test 'should route to all users' do
    assert_routing '/api/v1/users', { format: 'json', controller: 'api/v1/users', action: 'index' }
  end

  test 'should route to create user' do
    assert_routing({ method: 'post', path: '/api/v1/users' }, { format: 'json', controller: 'api/v1/users', action: 'create' })
  end
end