require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  setup do
    admin = create(:admin)
    sign_in admin
  end

  test 'should get show' do
    user = create(:user)
    get :show, params: { id: user.id }
    sign_in user
    assert_response :success
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get edit' do
    user = create(:user)
    get :edit, params: { id: user.id }
    assert_response :success
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should post create' do
    user_attrs = attributes_for(:user)
    post :create, params: { user: user_attrs }
    created_user = User.find_by(email: user_attrs[:email])

    assert created_user.present?
    assert created_user[:first_name] == user_attrs[:first_name]
    assert created_user[:last_name] == user_attrs[:last_name]
    assert created_user[:email] == user_attrs[:email]
    assert created_user.authenticate(user_attrs[:password]) == created_user
  end

  test 'should patch update' do
    user = create(:user)
    user_attrs = attributes_for(:user)
    patch :update, params: { id: user.id, user: user_attrs }
    patched_user = User.find(user.id)

    assert patched_user[:first_name] == user_attrs[:first_name]
    assert patched_user[:last_name] == user_attrs[:last_name]
    assert patched_user[:email] == user_attrs[:email]
    assert patched_user.authenticate(user_attrs[:password]) == patched_user
  end

  test 'should delete destroy' do
    user = create(:user)
    delete :destroy, params: { id: user.id }
    assert_not User.exists?(user.id)
  end
end
