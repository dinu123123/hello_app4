require 'test_helper'

class FuelExpensesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get fuel_expenses_index_url
    assert_response :success
  end

  test "should get import" do
    get fuel_expenses_import_url
    assert_response :success
  end

end
