require 'test_helper'

class InvoicedTripsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @invoiced_trip = invoiced_trips(:one)
  end

  test "should get index" do
    get invoiced_trips_url
    assert_response :success
  end

  test "should get new" do
    get new_invoiced_trip_url
    assert_response :success
  end

  test "should create invoiced_trip" do
    assert_difference('InvoicedTrip.count') do
      post invoiced_trips_url, params: { invoiced_trip: { DRIVER_id: @invoiced_trip.DRIVER_id, belgium_toll: @invoiced_trip.belgium_toll, client_id: @invoiced_trip.client_id, france_toll: @invoiced_trip.france_toll, germany_toll: @invoiced_trip.germany_toll, italy_toll: @invoiced_trip.italy_toll, km: @invoiced_trip.km, netherlands_toll: @invoiced_trip.netherlands_toll, swiss_toll: @invoiced_trip.swiss_toll, total_amount: @invoiced_trip.total_amount, truck_id: @invoiced_trip.truck_id, uk_toll: @invoiced_trip.uk_toll } }
    end

    assert_redirected_to invoiced_trip_url(InvoicedTrip.last)
  end

  test "should show invoiced_trip" do
    get invoiced_trip_url(@invoiced_trip)
    assert_response :success
  end

  test "should get edit" do
    get edit_invoiced_trip_url(@invoiced_trip)
    assert_response :success
  end

  test "should update invoiced_trip" do
    patch invoiced_trip_url(@invoiced_trip), params: { invoiced_trip: { DRIVER_id: @invoiced_trip.DRIVER_id, belgium_toll: @invoiced_trip.belgium_toll, client_id: @invoiced_trip.client_id, france_toll: @invoiced_trip.france_toll, germany_toll: @invoiced_trip.germany_toll, italy_toll: @invoiced_trip.italy_toll, km: @invoiced_trip.km, netherlands_toll: @invoiced_trip.netherlands_toll, swiss_toll: @invoiced_trip.swiss_toll, total_amount: @invoiced_trip.total_amount, truck_id: @invoiced_trip.truck_id, uk_toll: @invoiced_trip.uk_toll } }
    assert_redirected_to invoiced_trip_url(@invoiced_trip)
  end

  test "should destroy invoiced_trip" do
    assert_difference('InvoicedTrip.count', -1) do
      delete invoiced_trip_url(@invoiced_trip)
    end

    assert_redirected_to invoiced_trips_url
  end
end
