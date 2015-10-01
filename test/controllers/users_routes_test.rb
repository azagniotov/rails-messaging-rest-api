class UsersRoutesTest < ActionController::TestCase
  test 'should route to user by id' do
    assert_routing '/api/v1/users/1', { format: 'json', controller: 'api/v1/users', action: 'show', user_id: '1' }
  end

  test 'should route to create user' do
    assert_routing({ method: 'post', path: '/api/v1/users' }, { format: 'json', controller: 'api/v1/users', action: 'create' })
  end
end