require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @name = 'Alex'
    @email = 'azagniotov@gmail.com'
    @password = '12345'
  end

  def teardown
    User.delete_all
  end

  test 'should save new user to DB when all required properties are set' do
    user = User.new(name: @name, email: @email, password: @password)
    assert user.save
  end

  test 'should not save new user to DB when name is not set' do
    user = User.new(email: @email, password: @password)
    assert_not user.save
  end

  test 'should not save new user to DB when email is not set' do
    user = User.new(name: @name, password: @password)
    assert_not user.save
  end

  test 'should not save new user to DB when password is not set' do
    user = User.new(name: @name, email: @email)
    assert_not user.save
  end

  test 'should authenticate user when email & password are correct' do
    user = User.new(name: @name, email: @email, password: @password)
    assert user.save

    auth_token = User.authenticate(@email, @password)
    assert_equal(user.auth_token, auth_token)
  end

  test 'should not authenticate user when email is wrong' do
    user = User.new(name: @name, email: @email, password: @password)
    assert user.save

    auth_token = User.authenticate('wrongov@gmail.com', @password)
    assert_nil auth_token
  end

  test 'should not authenticate user when password is wrong' do
    user = User.new(name: @name, email: @email, password: @password)
    assert user.save

    auth_token = User.authenticate(@email, '123')
    assert_nil auth_token
  end
end
