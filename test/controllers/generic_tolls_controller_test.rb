require 'test_helper'

class GenericTollsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @generic_toll = generic_tolls(:one)
  end

  test "should get index" do
    get generic_tolls_url
    assert_response :success
  end

  test "should get new" do
    get new_generic_toll_url
    assert_response :success
  end

  test "should create generic_toll" do
    assert_difference('GenericToll.count') do
      post generic_tolls_url, params: { generic_toll: { EUR: @generic_toll.EUR, EndDate: @generic_toll.EndDate, Km: @generic_toll.Km, StartDate: @generic_toll.StartDate, country: @generic_toll.country, truck_id: @generic_toll.truck_id } }
    end

    assert_redirected_to generic_toll_url(GenericToll.last)
  end

  test "should show generic_toll" do
    get generic_toll_url(@generic_toll)
    assert_response :success
  end

  test "should get edit" do
    get edit_generic_toll_url(@generic_toll)
    assert_response :success
  end

  test "should update generic_toll" do
    patch generic_toll_url(@generic_toll), params: { generic_toll: { EUR: @generic_toll.EUR, EndDate: @generic_toll.EndDate, Km: @generic_toll.Km, StartDate: @generic_toll.StartDate, country: @generic_toll.country, truck_id: @generic_toll.truck_id } }
    assert_redirected_to generic_toll_url(@generic_toll)
  end

  test "should destroy generic_toll" do
    assert_difference('GenericToll.count', -1) do
      delete generic_toll_url(@generic_toll)
    end

    assert_redirected_to generic_tolls_url
  end
end
