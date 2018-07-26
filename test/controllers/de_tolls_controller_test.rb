require 'test_helper'

class DeTollsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @de_toll = de_tolls(:one)
  end

  test "should get index" do
    get de_tolls_url
    assert_response :success
  end

  test "should get new" do
    get new_de_toll_url
    assert_response :success
  end

  test "should create de_toll" do
    assert_difference('DeToll.count') do
      post de_tolls_url, params: 
 { de_toll: { art: @de_toll.art, axelclass: @de_toll.axelclass, 
      bookingid: @de_toll.bookingid, costcentre: @de_toll.costcentre, 
      date: @de_toll.date, departure: @de_toll.departure, eur: @de_toll.eur, 
      emissioncat: @de_toll.emissioncat, km: @de_toll.km, platenr: @de_toll.platenr, 
      road: @de_toll.road, roadoperators: @de_toll.roadoperators, 
      tariffmodel: @de_toll.tariffmodel, time: @de_toll.time, 
      ver: @de_toll.ver, via: @de_toll.via, 
      weightclass: @de_toll.weightclass, truck_id: @de_toll.truck_id } }

    end

    assert_redirected_to de_toll_url(DeToll.last)
  end

  test "should show de_toll" do
    get de_toll_url(@de_toll)
    assert_response :success
  end

  test "should get edit" do
    get edit_de_toll_url(@de_toll)
    assert_response :success
  end

  test "should update de_toll" do
    patch de_toll_url(@de_toll), 
    params:
     { de_toll: { art: @de_toll.art, axelclass: @de_toll.axelclass, 
      bookingid: @de_toll.bookingid, costcentre: @de_toll.costcentre, 
      date: @de_toll.date, departure: @de_toll.departure, eur: @de_toll.eur, 
      emissioncat: @de_toll.emissioncat, km: @de_toll.km, platenr: @de_toll.platenr, 
      road: @de_toll.road, roadoperators: @de_toll.roadoperators, 
      tariffmodel: @de_toll.tariffmodel, time: @de_toll.time, 
      ver: @de_toll.ver, via: @de_toll.via, 
      weightclass: @de_toll.weightclass, truck_id: @de_toll.truck_id } }
    assert_redirected_to de_toll_url(@de_toll)
  end

  test "should destroy de_toll" do
    assert_difference('DeToll.count', -1) do
      delete de_toll_url(@de_toll)
    end

    assert_redirected_to de_tolls_url
  end
end
