require 'test_helper'

class TruckExpensesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @truck_expense = truck_expenses(:one)
  end

  test "should get index" do
    get truck_expenses_url
    assert_response :success
  end

  test "should get new" do
    get new_truck_expense_url
    assert_response :success
  end

  test "should create truck_expense" do
    assert_difference('TruckExpense.count') do
      post truck_expenses_url, params: { truck_expense: { AMOUNT: @truck_expense.AMOUNT, DATETIME: @truck_expense.DATETIME, DESCRIPTION: @truck_expense.DESCRIPTION, INFO: @truck_expense.INFO, truck_id: @truck_expense.truck_id } }
    end

    assert_redirected_to truck_expense_url(TruckExpense.last)
  end

  test "should show truck_expense" do
    get truck_expense_url(@truck_expense)
    assert_response :success
  end

  test "should get edit" do
    get edit_truck_expense_url(@truck_expense)
    assert_response :success
  end

  test "should update truck_expense" do
    patch truck_expense_url(@truck_expense), params: { truck_expense: { AMOUNT: @truck_expense.AMOUNT, DATETIME: @truck_expense.DATETIME, DESCRIPTION: @truck_expense.DESCRIPTION, INFO: @truck_expense.INFO, truck_id: @truck_expense.truck_id } }
    assert_redirected_to truck_expense_url(@truck_expense)
  end

  test "should destroy truck_expense" do
    assert_difference('TruckExpense.count', -1) do
      delete truck_expense_url(@truck_expense)
    end

    assert_redirected_to truck_expenses_url
  end
end
