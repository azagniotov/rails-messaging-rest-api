require 'test_helper'

class API::V1::UsersControllerTest < ActionController::TestCase

  test 'should not get user by id when API key header is not set' do
    get :show, user_id: 8

    json_response = ActiveSupport::JSON.decode response.body
    assert_equal 'X-Api-Key header is not set', json_response['description']
    assert_equal 403, json_response['code']
    assert_equal '403', response.code
  end

  test 'should not get user by id when API key is not valid' do
    request.headers['X-Api-Key'] = '4j2h3b423b4kj23b4kl23j'
    get :show, user_id: 8

    json_response = ActiveSupport::JSON.decode response.body
    assert_equal 'Api key is not valid', json_response['description']
    assert_equal 403, json_response['code']
    assert_equal '403', response.code
  end
end