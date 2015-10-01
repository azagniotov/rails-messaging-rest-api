class SessionsFlowsTest < ActionDispatch::IntegrationTest

  test 'should not authenticate user when "basic access authentication" header is not set' do
    get '/api/v1/sessions'

    assert_equal 'HTTP Basic: Access denied.', response.body.strip
    assert_equal '401', response.code
  end

  test 'should not authenticate user with wrong password' do
    post '/api/v1/users', :user => { :name => 'Alex', :email => 'wow@gmail.com', :password => '54321' }
    post_json_response = ActiveSupport::JSON.decode response.body
    assert_not_nil post_json_response

    basic = ActionController::HttpAuthentication::Basic
    credentials = basic.encode_credentials('wow@gmail.com', '12345')
    get '/api/v1/sessions', nil, {'Authorization': credentials}

    assert_equal 'HTTP Basic: Access denied.', response.body.strip
    assert_equal '401', response.code
  end

  test 'should authenticate user by correct credentials' do
    post '/api/v1/users', :user => { :name => 'Alex', :email => 'wow@gmail.com', :password => '54321' }
    post_json_response = ActiveSupport::JSON.decode response.body
    assert_not_nil post_json_response

    basic = ActionController::HttpAuthentication::Basic
    credentials = basic.encode_credentials('wow@gmail.com', '54321')
    get '/api/v1/sessions', nil, {'Authorization': credentials}

    assert_equal post_json_response['data']['attributes']['auth_token'], response.body
    assert_equal '200', response.code
  end
end