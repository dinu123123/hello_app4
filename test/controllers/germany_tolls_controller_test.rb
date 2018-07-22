require 'test_helper'

class GermanyTollsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get germany_tolls_index_url
    assert_response :success
  end

  test "should get import" do
    get germany_tolls_import_url
    assert_response :success
  end

end
