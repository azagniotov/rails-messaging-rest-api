class SessionsFlowsTest < ActionDispatch::IntegrationTest

  def setup
    @email = 'yay@gmail.com'
    @password = '54321'
    post '/api/v1/users', :user => { :name => 'Alex', :email => @email, :password => @password }
    assert_not_nil ActiveSupport::JSON.decode response.body

    @basic = ActionController::HttpAuthentication::Basic
  end

  def teardown
    User.delete_all
  end

  test 'should not authenticate user when "basic access authentication" header is not set' do
    get '/api/v1/sessions'

    assert_equal 'HTTP Basic: Access denied.', response.body.strip
    assert_equal '401', response.code
  end

  test 'should not authenticate user with wrong password' do
    credentials = @basic.encode_credentials('wow@gmail.com', @password)
    get '/api/v1/sessions', nil, {'Authorization': credentials}

    assert_equal 'HTTP Basic: Access denied.', response.body.strip
    assert_equal '401', response.code
  end

  test 'should authenticate user by correct credentials' do
    credentials = @basic.encode_credentials(@email, @password)
    get '/api/v1/sessions', nil, {'Authorization': credentials}

    assert_not_nil response.body
    assert_equal '200', response.code
  end
end