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
      post de_tolls_url, params: { de_toll: { Art: @de_toll.Art, AxelClass: @de_toll.AxelClass, BookingID: @de_toll.BookingID, CostCentre: @de_toll.CostCentre, Date: @de_toll.Date, Departure: @de_toll.Departure, EUR: @de_toll.EUR, EmissionCat: @de_toll.EmissionCat, Km: @de_toll.Km, PlateNr: @de_toll.PlateNr, Road: @de_toll.Road, RoadOperators: @de_toll.RoadOperators, TariffModel: @de_toll.TariffModel, Time: @de_toll.Time, Ver: @de_toll.Ver, Via: @de_toll.Via, WeightClass: @de_toll.WeightClass, truck_id: @de_toll.truck_id } }
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
    patch de_toll_url(@de_toll), params: { de_toll: { Art: @de_toll.Art, AxelClass: @de_toll.AxelClass, BookingID: @de_toll.BookingID, CostCentre: @de_toll.CostCentre, Date: @de_toll.Date, Departure: @de_toll.Departure, EUR: @de_toll.EUR, EmissionCat: @de_toll.EmissionCat, Km: @de_toll.Km, PlateNr: @de_toll.PlateNr, Road: @de_toll.Road, RoadOperators: @de_toll.RoadOperators, TariffModel: @de_toll.TariffModel, Time: @de_toll.Time, Ver: @de_toll.Ver, Via: @de_toll.Via, WeightClass: @de_toll.WeightClass, truck_id: @de_toll.truck_id } }
    assert_redirected_to de_toll_url(@de_toll)
  end

  test "should destroy de_toll" do
    assert_difference('DeToll.count', -1) do
      delete de_toll_url(@de_toll)
    end

    assert_redirected_to de_tolls_url
  end
end
