require 'test_helper'

class Web::PasswordsControllerTest < ActionController::TestCase
  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should post create' do
    user = create(:user)

    assert_emails 1 do
      post :create, params: { user: { email: user.email } }
    end

    assert_response :redirect
  end

  test 'should get edit' do
    user = create(:user)
    user.create_password_reset_token
    attrs = { token: user.password_reset_token }

    get :edit, params: attrs
    assert_response :success
  end

  test 'should put update' do
    user = create(:user)
    user.create_password_reset_token
    password = generate(:string)
    attrs = { user: { password: password, password_confirmation: password }, token: user.password_reset_token }

    put :update, params: attrs

    assert_response :redirect

    assert user
  end
end
