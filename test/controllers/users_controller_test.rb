require 'test_helper'

class API::V1::UsersControllerTest < ActionController::TestCase
  setup do
    request.headers['Content-Type'] = 'application/json'
  end

  test 'should not get user by id when API key header is not set' do
    get :show, user_id: 8

    json_response = ActiveSupport::JSON.decode response.body
    assert_equal 'X-Api-Key header is not set', json_response['status']
    assert_equal '401', response.code
  end

  test 'should not get user by id when API key is not valid' do
    request.headers['X-Api-Key'] = '4j2h3b423b4kj23b4kl23j'
    get :show, user_id: 8

    json_response = ActiveSupport::JSON.decode response.body
    assert_equal 'Api key is not valid', json_response['status']
    assert_equal '401', response.code
  end

  test 'should get user by id' do
    post :create, :user => { :name => 'Alex', :email => 'yay@gmail.com', :password => '54321' }
    post_json_response = ActiveSupport::JSON.decode response.body
    assert_not_nil post_json_response

    user_id = post_json_response['data']['id']
    auth_token = post_json_response['data']['attributes']['auth_token']

    request.headers['X-Api-Key'] = auth_token
    get :show, user_id: user_id
    get_json_response = ActiveSupport::JSON.decode response.body

    assert_equal auth_token, get_json_response['data']['attributes']['auth_token']
    assert_equal '200', response.code
  end

end