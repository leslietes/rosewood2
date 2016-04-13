require 'test_helper'

class UtilitiesControllerTest < ActionController::TestCase
  setup do
    @utility = utilities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:utilities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create utility" do
    assert_difference('Utility.count') do
      post :create, utility: {  }
    end

    assert_redirected_to utility_path(assigns(:utility))
  end

  test "should show utility" do
    get :show, id: @utility
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @utility
    assert_response :success
  end

  test "should update utility" do
    patch :update, id: @utility, utility: {  }
    assert_redirected_to utility_path(assigns(:utility))
  end

  test "should destroy utility" do
    assert_difference('Utility.count', -1) do
      delete :destroy, id: @utility
    end

    assert_redirected_to utilities_path
  end
end
