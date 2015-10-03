class UsersFlowsTest < ActionDispatch::IntegrationTest

  test 'should create user' do
    post '/api/v1/users', :user => { :name => 'Alex', :email => 'azagniotov@gmail.com', :password => '54321' }
    json_response = ActiveSupport::JSON.decode response.body

    assert_not_nil json_response
    assert_equal 'azagniotov@gmail.com', json_response['data']['attributes']['email']
    assert_equal '201', response.code
  end

  test 'should not get user by id when API key header is not set' do
    get '/api/v1/users/1'
    json_response = ActiveSupport::JSON.decode response.body

    assert_not_nil json_response
    assert_equal 'X-Api-Key header is not set', json_response['description']
    assert_equal 401, json_response['code']
    assert_equal '401', response.code
  end

  test 'should not get user by id when API key header value is wrong' do
    get '/api/v1/users/1', nil, {'X-Api-Key': 'blahblah'}
    json_response = ActiveSupport::JSON.decode response.body

    assert_not_nil json_response
    assert_equal 'Api key is not valid', json_response['description']
    assert_equal 401, json_response['code']
    assert_equal '401', response.code
  end

  test 'should get user by id' do
    post '/api/v1/users', :user => { :name => 'Alex', :email => 'yay@gmail.com', :password => '54321' }
    post_json_response = ActiveSupport::JSON.decode response.body
    assert_not_nil post_json_response

    user_id = post_json_response['data']['id']
    auth_token = post_json_response['data']['attributes']['auth_token']
    get "/api/v1/users/#{user_id}", nil, {'X-Api-Key': auth_token}
    get_json_response = ActiveSupport::JSON.decode response.body

    assert_equal auth_token, get_json_response['data']['attributes']['auth_token']
    assert_equal '200', response.code
  end

  test 'should get all users' do
    post '/api/v1/users', :user => { :name => 'Alex', :email => 'yay@gmail.com', :password => '54321' }
    post_json_response = ActiveSupport::JSON.decode response.body
    assert_not_nil post_json_response

    auth_token = post_json_response['data']['attributes']['auth_token']
    get '/api/v1/users', nil, {'X-Api-Key': auth_token}
    get_json_response = ActiveSupport::JSON.decode response.body

    assert_equal auth_token, get_json_response['data'][0]['attributes']['auth_token']
    assert_equal '200', response.code
  end
end