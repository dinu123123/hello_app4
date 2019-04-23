require 'test_helper'

class As24GermanyTollsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @as24_germany_toll = as24_germany_tolls(:one)
  end

  test "should get index" do
    get as24_germany_tolls_url
    assert_response :success
  end

  test "should get new" do
    get new_as24_germany_toll_url
    assert_response :success
  end

  test "should create as24_germany_toll" do
    assert_difference('As24GermanyToll.count') do
      post as24_germany_tolls_url, params: { as24_germany_toll: { contract: @as24_germany_toll.contract, country: @as24_germany_toll.country, date: @as24_germany_toll.date, document_type: @as24_germany_toll.document_type, driver_card: @as24_germany_toll.driver_card, immatriculation: @as24_germany_toll.immatriculation, invoice_date: @as24_germany_toll.invoice_date, invoice_nbr: @as24_germany_toll.invoice_nbr, miles: @as24_germany_toll.miles, payment_currency: @as24_germany_toll.payment_currency, payment_excl_vat: @as24_germany_toll.payment_excl_vat, product: @as24_germany_toll.product, product_code: @as24_germany_toll.product_code, site_nbr: @as24_germany_toll.site_nbr, station: @as24_germany_toll.station, time: @as24_germany_toll.time, transaction_excl_vat: @as24_germany_toll.transaction_excl_vat, transaction_incl_vat: @as24_germany_toll.transaction_incl_vat, transaction_vat: @as24_germany_toll.transaction_vat, transation_currency: @as24_germany_toll.transation_currency, vat_rate: @as24_germany_toll.vat_rate, vehicle_card: @as24_germany_toll.vehicle_card, volume: @as24_germany_toll.volume } }
    end

    assert_redirected_to as24_germany_toll_url(As24GermanyToll.last)
  end

  test "should show as24_germany_toll" do
    get as24_germany_toll_url(@as24_germany_toll)
    assert_response :success
  end

  test "should get edit" do
    get edit_as24_germany_toll_url(@as24_germany_toll)
    assert_response :success
  end

  test "should update as24_germany_toll" do
    patch as24_germany_toll_url(@as24_germany_toll), params: { as24_germany_toll: { contract: @as24_germany_toll.contract, country: @as24_germany_toll.country, date: @as24_germany_toll.date, document_type: @as24_germany_toll.document_type, driver_card: @as24_germany_toll.driver_card, immatriculation: @as24_germany_toll.immatriculation, invoice_date: @as24_germany_toll.invoice_date, invoice_nbr: @as24_germany_toll.invoice_nbr, miles: @as24_germany_toll.miles, payment_currency: @as24_germany_toll.payment_currency, payment_excl_vat: @as24_germany_toll.payment_excl_vat, product: @as24_germany_toll.product, product_code: @as24_germany_toll.product_code, site_nbr: @as24_germany_toll.site_nbr, station: @as24_germany_toll.station, time: @as24_germany_toll.time, transaction_excl_vat: @as24_germany_toll.transaction_excl_vat, transaction_incl_vat: @as24_germany_toll.transaction_incl_vat, transaction_vat: @as24_germany_toll.transaction_vat, transation_currency: @as24_germany_toll.transation_currency, vat_rate: @as24_germany_toll.vat_rate, vehicle_card: @as24_germany_toll.vehicle_card, volume: @as24_germany_toll.volume } }
    assert_redirected_to as24_germany_toll_url(@as24_germany_toll)
  end

  test "should destroy as24_germany_toll" do
    assert_difference('As24GermanyToll.count', -1) do
      delete as24_germany_toll_url(@as24_germany_toll)
    end

    assert_redirected_to as24_germany_tolls_url
  end
end
