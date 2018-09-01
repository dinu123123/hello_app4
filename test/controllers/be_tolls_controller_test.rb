require 'test_helper'

class BeTollsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @be_toll = be_tolls(:one)
  end

  test "should get index" do
    get be_tolls_url
    assert_response :success
  end

  test "should get new" do
    get new_be_toll_url
    assert_response :success
  end

  test "should create be_toll" do
    assert_difference('BeToll.count') do
      post be_tolls_url, params: { be_toll: { bill_cycle_end_date: @be_toll.bill_cycle_end_date, bill_cycle_start_date: @be_toll.bill_cycle_start_date, charged_amount_excluding_vat: @be_toll.charged_amount_excluding_vat, charged_distance: @be_toll.charged_distance, country_code: @be_toll.country_code, currency: @be_toll.currency, date_of_detailed_trip_statement: @be_toll.date_of_detailed_trip_statement, date_of_processing: @be_toll.date_of_processing, date_of_usage: @be_toll.date_of_usage, distance_unit: @be_toll.distance_unit, entry_time: @be_toll.entry_time, euro_emission_class: @be_toll.euro_emission_class, gross_combination_weight: @be_toll.gross_combination_weight, identification_of_the_road_network_user: @be_toll.identification_of_the_road_network_user, internal_obu_identifier: @be_toll.internal_obu_identifier, licence_plate_number: @be_toll.licence_plate_number, obu_serial_number: @be_toll.obu_serial_number, payment_method: @be_toll.payment_method, record_number: @be_toll.record_number, reference_number: @be_toll.reference_number, road_type: @be_toll.road_type, route: @be_toll.route, toll_charger: @be_toll.toll_charger, vat_indicator: @be_toll.vat_indicator } }
    end

    assert_redirected_to be_toll_url(BeToll.last)
  end

  test "should show be_toll" do
    get be_toll_url(@be_toll)
    assert_response :success
  end

  test "should get edit" do
    get edit_be_toll_url(@be_toll)
    assert_response :success
  end

  test "should update be_toll" do
    patch be_toll_url(@be_toll), params: { be_toll: { bill_cycle_end_date: @be_toll.bill_cycle_end_date, bill_cycle_start_date: @be_toll.bill_cycle_start_date, charged_amount_excluding_vat: @be_toll.charged_amount_excluding_vat, charged_distance: @be_toll.charged_distance, country_code: @be_toll.country_code, currency: @be_toll.currency, date_of_detailed_trip_statement: @be_toll.date_of_detailed_trip_statement, date_of_processing: @be_toll.date_of_processing, date_of_usage: @be_toll.date_of_usage, distance_unit: @be_toll.distance_unit, entry_time: @be_toll.entry_time, euro_emission_class: @be_toll.euro_emission_class, gross_combination_weight: @be_toll.gross_combination_weight, identification_of_the_road_network_user: @be_toll.identification_of_the_road_network_user, internal_obu_identifier: @be_toll.internal_obu_identifier, licence_plate_number: @be_toll.licence_plate_number, obu_serial_number: @be_toll.obu_serial_number, payment_method: @be_toll.payment_method, record_number: @be_toll.record_number, reference_number: @be_toll.reference_number, road_type: @be_toll.road_type, route: @be_toll.route, toll_charger: @be_toll.toll_charger, vat_indicator: @be_toll.vat_indicator } }
    assert_redirected_to be_toll_url(@be_toll)
  end

  test "should destroy be_toll" do
    assert_difference('BeToll.count', -1) do
      delete be_toll_url(@be_toll)
    end

    assert_redirected_to be_tolls_url
  end
end
