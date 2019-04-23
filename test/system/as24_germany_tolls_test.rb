require "application_system_test_case"

class As24GermanyTollsTest < ApplicationSystemTestCase
  setup do
    @as24_germany_toll = as24_germany_tolls(:one)
  end

  test "visiting the index" do
    visit as24_germany_tolls_url
    assert_selector "h1", text: "As24 Germany Tolls"
  end

  test "creating a As24 germany toll" do
    visit as24_germany_tolls_url
    click_on "New As24 Germany Toll"

    fill_in "Contract", with: @as24_germany_toll.contract
    fill_in "Country", with: @as24_germany_toll.country
    fill_in "Date", with: @as24_germany_toll.date
    fill_in "Document Type", with: @as24_germany_toll.document_type
    fill_in "Driver Card", with: @as24_germany_toll.driver_card
    fill_in "Immatriculation", with: @as24_germany_toll.immatriculation
    fill_in "Invoice Date", with: @as24_germany_toll.invoice_date
    fill_in "Invoice Nbr", with: @as24_germany_toll.invoice_nbr
    fill_in "Miles", with: @as24_germany_toll.miles
    fill_in "Payment Currency", with: @as24_germany_toll.payment_currency
    fill_in "Payment Excl Vat", with: @as24_germany_toll.payment_excl_vat
    fill_in "Product", with: @as24_germany_toll.product
    fill_in "Product Code", with: @as24_germany_toll.product_code
    fill_in "Site Nbr", with: @as24_germany_toll.site_nbr
    fill_in "Station", with: @as24_germany_toll.station
    fill_in "Time", with: @as24_germany_toll.time
    fill_in "Transaction Excl Vat", with: @as24_germany_toll.transaction_excl_vat
    fill_in "Transaction Incl Vat", with: @as24_germany_toll.transaction_incl_vat
    fill_in "Transaction Vat", with: @as24_germany_toll.transaction_vat
    fill_in "Transation Currency", with: @as24_germany_toll.transation_currency
    fill_in "Vat Rate", with: @as24_germany_toll.vat_rate
    fill_in "Vehicle Card", with: @as24_germany_toll.vehicle_card
    fill_in "Volume", with: @as24_germany_toll.volume
    click_on "Create As24 germany toll"

    assert_text "As24 germany toll was successfully created"
    click_on "Back"
  end

  test "updating a As24 germany toll" do
    visit as24_germany_tolls_url
    click_on "Edit", match: :first

    fill_in "Contract", with: @as24_germany_toll.contract
    fill_in "Country", with: @as24_germany_toll.country
    fill_in "Date", with: @as24_germany_toll.date
    fill_in "Document Type", with: @as24_germany_toll.document_type
    fill_in "Driver Card", with: @as24_germany_toll.driver_card
    fill_in "Immatriculation", with: @as24_germany_toll.immatriculation
    fill_in "Invoice Date", with: @as24_germany_toll.invoice_date
    fill_in "Invoice Nbr", with: @as24_germany_toll.invoice_nbr
    fill_in "Miles", with: @as24_germany_toll.miles
    fill_in "Payment Currency", with: @as24_germany_toll.payment_currency
    fill_in "Payment Excl Vat", with: @as24_germany_toll.payment_excl_vat
    fill_in "Product", with: @as24_germany_toll.product
    fill_in "Product Code", with: @as24_germany_toll.product_code
    fill_in "Site Nbr", with: @as24_germany_toll.site_nbr
    fill_in "Station", with: @as24_germany_toll.station
    fill_in "Time", with: @as24_germany_toll.time
    fill_in "Transaction Excl Vat", with: @as24_germany_toll.transaction_excl_vat
    fill_in "Transaction Incl Vat", with: @as24_germany_toll.transaction_incl_vat
    fill_in "Transaction Vat", with: @as24_germany_toll.transaction_vat
    fill_in "Transation Currency", with: @as24_germany_toll.transation_currency
    fill_in "Vat Rate", with: @as24_germany_toll.vat_rate
    fill_in "Vehicle Card", with: @as24_germany_toll.vehicle_card
    fill_in "Volume", with: @as24_germany_toll.volume
    click_on "Update As24 germany toll"

    assert_text "As24 germany toll was successfully updated"
    click_on "Back"
  end

  test "destroying a As24 germany toll" do
    visit as24_germany_tolls_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "As24 germany toll was successfully destroyed"
  end
end
