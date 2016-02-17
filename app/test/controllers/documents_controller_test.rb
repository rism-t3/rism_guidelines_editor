class DocumentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  def setup
    sign_in admin_users(:admin)
     @controller = Admin::DocumentsController.new
  end
  
  test "should get index" do
    get :index
    assert_response :success
  end
end
