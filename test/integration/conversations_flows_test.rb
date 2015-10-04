class ConversationsFlowsTest < ActionDispatch::IntegrationTest

  def setup
    @name = 'Alex'
    @email = 'yay@gmail.com'
    @password = '54321'
    @message = 'This is a text message '
    post '/api/v1/users', :user => {:name => @name, :email => @email, :password => @password}
    @create_user_json_response = ActiveSupport::JSON.decode response.body
    assert_not_nil @create_user_json_response

    @basic = ActionController::HttpAuthentication::Basic
    credentials = @basic.encode_credentials(@email, @password)
    get '/api/v1/sessions', nil, {'Authorization': credentials}
    @auth_token = response.body

    @user_id = @create_user_json_response['data']['id']
    post '/api/v1/conversations', {:conversation => {:started_by => @user_id, :message => 'Message', :recipient_ids => [8, 9]}}, {'X-Api-Key': @auth_token}
    @conversation_json_response = ActiveSupport::JSON.decode response.body
  end

  test 'should create new conversation when all params are valid' do
    assert_equal "#{@user_id}", @conversation_json_response['data']['attributes']['started_by'].to_s
    assert_equal '/api/v1/conversations/1', @conversation_json_response['data']['attributes']['links']['self']
  end

  test 'should not create new conversation when "started_by" user id does not exist' do
    post '/api/v1/conversations', {:conversation => {:started_by => 123456, :message => 'Message', :recipient_ids => [8, 9]}}, {'X-Api-Key': @auth_token}
    error_json_response = ActiveSupport::JSON.decode response.body

    assert_not_nil error_json_response
    assert_equal "User with id '123456' does not exist", error_json_response['description']
    assert_equal '400', response.code
  end

  test 'should get all conversations' do
    get '/api/v1/conversations', nil, {'X-Api-Key': @auth_token}
    get_json_response = ActiveSupport::JSON.decode response.body

    assert_equal @conversation_json_response['data']['id'], get_json_response['data'][0]['id']
    assert_equal '200', response.code
  end

  def teardown
    User.delete_all
    Message.delete_all
    Conversation.delete_all
  end

end