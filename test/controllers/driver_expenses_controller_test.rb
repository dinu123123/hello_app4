require 'test_helper'

class DriverExpensesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @driver_expense = driver_expenses(:one)
  end

  test "should get index" do
    get driver_expenses_url
    assert_response :success
  end

  test "should get new" do
    get new_driver_expense_url
    assert_response :success
  end

  test "should create driver_expense" do
    assert_difference('DriverExpense.count') do
      post driver_expenses_url, params: { driver_expense: { AMOUNT: @driver_expense.AMOUNT, DATETIME: @driver_expense.DATETIME, DESCRIPTION: @driver_expense.DESCRIPTION, DRIVER_id: @driver_expense.DRIVER_id, INFO: @driver_expense.INFO } }
    end

    assert_redirected_to driver_expense_url(DriverExpense.last)
  end

  test "should show driver_expense" do
    get driver_expense_url(@driver_expense)
    assert_response :success
  end

  test "should get edit" do
    get edit_driver_expense_url(@driver_expense)
    assert_response :success
  end

  test "should update driver_expense" do
    patch driver_expense_url(@driver_expense), params: { driver_expense: { AMOUNT: @driver_expense.AMOUNT, DATETIME: @driver_expense.DATETIME, DESCRIPTION: @driver_expense.DESCRIPTION, DRIVER_id: @driver_expense.DRIVER_id, INFO: @driver_expense.INFO } }
    assert_redirected_to driver_expense_url(@driver_expense)
  end

  test "should destroy driver_expense" do
    assert_difference('DriverExpense.count', -1) do
      delete driver_expense_url(@driver_expense)
    end

    assert_redirected_to driver_expenses_url
  end
end
