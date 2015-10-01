require 'test_helper'

class API::V1::SessionsControllerTest < ActionController::TestCase
  setup do
    request.headers['Accept'] = 'application/json'
    request.headers['Content-Type'] = 'application/json'
  end


  test 'should not authenticate user when "basic access authentication" header is not set' do
    get :index

    assert_equal 'HTTP Basic: Access denied.', response.body.strip
    assert_equal '401', response.code
  end

  test 'should not authenticate user with wrong "basic access authentication" header value' do
    basic = ActionController::HttpAuthentication::Basic
    credentials = basic.encode_credentials('wow@gmail.com', '54321')
    request.headers['Authorization'] = credentials
    get :index

    assert_equal 'HTTP Basic: Access denied.', response.body.strip
    assert_equal '401', response.code
  end

end