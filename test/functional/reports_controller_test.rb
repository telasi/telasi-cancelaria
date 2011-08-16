require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  test "should get not_completed_letters" do
    get :not_completed_letters
    assert_response :success
  end

end
