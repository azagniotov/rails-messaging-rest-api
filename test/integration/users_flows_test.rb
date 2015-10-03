class UsersFlowsTest < ActionDispatch::IntegrationTest

  def setup
    @name = 'Alex'
    @email = 'yay@gmail.com'
    @password = '54321'
    post '/api/v1/users', :user => { :name => @name, :email => @email, :password => @password }
    @create_user_json_response = ActiveSupport::JSON.decode response.body
    assert_not_nil @create_user_json_response
    assert_equal '201', response.code

    @basic = ActionController::HttpAuthentication::Basic
    credentials = @basic.encode_credentials(@email, @password)
    get '/api/v1/sessions', nil, {'Authorization': credentials}
    @auth_token = response.body
  end

  def teardown
    User.delete_all
  end

  test 'should return expected data in create user JSON response' do
    assert_equal @name, @create_user_json_response['data']['attributes']['name']
    assert_equal @email, @create_user_json_response['data']['attributes']['email']
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
    user_id = @create_user_json_response['data']['id']
    get "/api/v1/users/#{user_id}", nil, {'X-Api-Key': @auth_token}
    get_json_response = ActiveSupport::JSON.decode response.body

    assert_equal user_id, get_json_response['data']['id']
    assert_equal '200', response.code
  end

  test 'should get all users' do
    get '/api/v1/users', nil, {'X-Api-Key': @auth_token}
    get_json_response = ActiveSupport::JSON.decode response.body

    assert_equal @create_user_json_response['data']['id'], get_json_response['data'][0]['id']
    assert_equal '200', response.code
  end

  test 'should get empty user conversations by user id' do
    user_id = @create_user_json_response['data']['id']
    get "/api/v1/users/#{user_id}/conversations", nil, {'X-Api-Key': @auth_token}
    get_json_response = ActiveSupport::JSON.decode response.body

    assert_not_nil get_json_response['data']['relationships']['conversations']
    assert_empty get_json_response['data']['relationships']['conversations']['data']
  end
end