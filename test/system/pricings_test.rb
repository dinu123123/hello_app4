require "application_system_test_case"

class PricingsTest < ApplicationSystemTestCase
  setup do
    @pricing = pricings(:one)
  end

  test "visiting the index" do
    visit pricings_url
    assert_selector "h1", text: "Pricings"
  end

  test "creating a Pricing" do
    visit pricings_url
    click_on "New Pricing"

    fill_in "Client", with: @pricing.CLIENT_id
    fill_in "Datetime", with: @pricing.DATETIME
    fill_in "Description", with: @pricing.DESCRIPTION
    fill_in "Price Per Day", with: @pricing.price_per_day
    fill_in "Price Per Km", with: @pricing.price_per_km
    fill_in "Surcharge", with: @pricing.surcharge
    click_on "Create Pricing"

    assert_text "Pricing was successfully created"
    click_on "Back"
  end

  test "updating a Pricing" do
    visit pricings_url
    click_on "Edit", match: :first

    fill_in "Client", with: @pricing.CLIENT_id
    fill_in "Datetime", with: @pricing.DATETIME
    fill_in "Description", with: @pricing.DESCRIPTION
    fill_in "Price Per Day", with: @pricing.price_per_day
    fill_in "Price Per Km", with: @pricing.price_per_km
    fill_in "Surcharge", with: @pricing.surcharge
    click_on "Update Pricing"

    assert_text "Pricing was successfully updated"
    click_on "Back"
  end

  test "destroying a Pricing" do
    visit pricings_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Pricing was successfully destroyed"
  end
end
