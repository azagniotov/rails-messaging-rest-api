class MessagesFlowsTest < ActionDispatch::IntegrationTest

  def setup
    @name = 'Alex'
    @email = 'yay@gmail.com'
    @password = '54321'
    @message = 'This is a text message '
    post '/api/v1/users', :user => {:name => @name, :email => @email, :password => @password}
    create_user_json_response = ActiveSupport::JSON.decode response.body
    assert_not_nil create_user_json_response

    basic = ActionController::HttpAuthentication::Basic
    credentials = basic.encode_credentials(@email, @password)
    get '/api/v1/sessions', nil, {'Authorization': credentials}
    authorization_json_response = ActiveSupport::JSON.decode response.body
    @auth_token = authorization_json_response['auth_token']

    @message_id = Message.create(sender_id: 12345, text: @message).id
  end

  def teardown
    User.delete_all
    Message.delete_all
  end

  test 'should get message by id' do
    get "/api/v1/messages/#{@message_id}", nil, {'X-Api-Key': @auth_token}
    get_json_response = ActiveSupport::JSON.decode response.body

    assert_equal "#{@message_id}", get_json_response['data']['id']
    assert_equal '200', response.code
  end

  test 'should not get message by id when API key header is not set' do
    get "/api/v1/messages/#{@message_id}"
    error_json_response = ActiveSupport::JSON.decode response.body

    assert_not_nil error_json_response
    assert_equal 'X-Api-Key header is not set', error_json_response['description']
    assert_equal 403, error_json_response['code']
    assert_equal '403', response.code
  end

end