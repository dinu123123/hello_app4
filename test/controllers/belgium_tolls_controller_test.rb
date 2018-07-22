require 'test_helper'

class BelgiumTollsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @belgium_toll = belgium_tolls(:one)
  end

  test "should get index" do
    get belgium_tolls_url
    assert_response :success
  end

  test "should get new" do
    get new_belgium_toll_url
    assert_response :success
  end

  test "should create belgium_toll" do
    assert_difference('BelgiumToll.count') do
      post belgium_tolls_url, params: { belgium_toll: { EUR: @belgium_toll.EUR, EndDate: @belgium_toll.EndDate, EndTime: @belgium_toll.EndTime, Km: @belgium_toll.Km, PlateNr: @belgium_toll.PlateNr, StartDate: @belgium_toll.StartDate, StartTime: @belgium_toll.StartTime } }
    end

    assert_redirected_to belgium_toll_url(BelgiumToll.last)
  end

  test "should show belgium_toll" do
    get belgium_toll_url(@belgium_toll)
    assert_response :success
  end

  test "should get edit" do
    get edit_belgium_toll_url(@belgium_toll)
    assert_response :success
  end

  test "should update belgium_toll" do
    patch belgium_toll_url(@belgium_toll), params: { belgium_toll: { EUR: @belgium_toll.EUR, EndDate: @belgium_toll.EndDate, EndTime: @belgium_toll.EndTime, Km: @belgium_toll.Km, PlateNr: @belgium_toll.PlateNr, StartDate: @belgium_toll.StartDate, StartTime: @belgium_toll.StartTime } }
    assert_redirected_to belgium_toll_url(@belgium_toll)
  end

  test "should destroy belgium_toll" do
    assert_difference('BelgiumToll.count', -1) do
      delete belgium_toll_url(@belgium_toll)
    end

    assert_redirected_to belgium_tolls_url
  end
end
