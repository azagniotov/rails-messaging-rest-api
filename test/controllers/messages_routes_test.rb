class MessagesRoutesTest < ActionController::TestCase
  test 'should route to message by id' do
    assert_routing '/api/v1/messages/1', {format: 'json', controller: 'api/v1/messages', action: 'show', message_id: '1'}
  end
end