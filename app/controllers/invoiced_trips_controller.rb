require 'json'
require 'invoice_printer'

class InvoicedTripsController < ApplicationController
  before_action :set_invoiced_trip, only: [:show, :edit, :update, :destroy]

  def import
    InvoicedTrip.import(params[:file])
    redirect_to invoiced_trips_url, notice: "Activity Data Imported!"
  end

  def create_multi_invoice
  end

  # GET /drivers
  # GET /drivers.json
  def index

  #  if(current_user.email.eql?  "ameropa.logistics@gmail.com")
  #  @invoiced_trips = InvoicedTrip.all
    @search = TransactionSearch.new(params[:search])
    @invoiced_trips = @search.scope_invoiced_trips_index
    #@invoiced_trips = InvoicedTrip.find_by_sql(['SELECT * FROM invoiced_trips ORDER BY invoiced_trips.date DESC'])
   

    @invoices = Invoice.all
    @trucks = Truck.all
    @clients = Client.all
    @drivers = Driver.all
    respond_to do |format|
        format.html
        format.csv { send_data @invoiced_trips.to_csv, filename: "invoiced_trips-#{Time.now.strftime('s%S/m%M/h%H/')+Date.today.strftime('d%d/m%m/y%Y')}.csv" }   
        format.xls #{ send_data @trucks.to_csv(col_sep: "\t") }
      end
   # else
   #   redirect_to root_path
   # end
  end

  # GET /invoiced_trips/1
  # GET /invoiced_trips/1.json
  def show
  end


 def print


#<InvoicedTrip 
#id: 1, 
#date: "2018-09-05", 
#StartDate: "2018-08-27 07:30:00", 
#EndDate: "2018-09-04 16:14:00", 
#invoice_id: "AL2015591_1", 
#client_id: 2, 
#DRIVER_id: 8, 
#truck_id: 8, 
#germany_toll: 0.38081e3, 
#belgium_toll: 0.0, 
#swiss_toll: 0.0, 
#france_toll: 0.0, 
#italy_toll: 0.0, 
#uk_toll: 0.0, 
#netherlands_toll: 0.0, 
#km: 3568, 
#km_evogps: 3767, 
#km_driver_route_note: 0, 
#total_amount: 0.348579e4, 
#created_at: "2018-09-11 22:10:55", 
#updated_at: "2018-09-13 17:42:56">
#>>  invoiced_trip.invoice_id

invoiced_trip = InvoicedTrip.find(params[:id])

client = Client.find(invoiced_trip.client_id)

item = InvoicePrinter::Document::Item.new(
  name: 'Transport  week '.to_s+invoiced_trip.date.strftime("%U").to_s+" ".to_s+Truck.find(invoiced_trip.truck_id).NB_PLATE,
  quantity: nil,
  unit: "piece".to_s,
  price: '1',
  amount: invoiced_trip.total_amount,
  tax: '0'  
)



labels = {
  name: 'Invoice',
  provider: 'Supplier:',
  purchaser: 'Purchaser:',
  tax_id: 'VAT',
  tax_id2: 'EUID',
  payment: 'Forma uhrady',
  payment_by_transfer: 'Payment by bank transfer on the account bellow:',
  account_number: 'IBAN:',
  bank_account_number: '',
  issue_date: 'Issue Date:',
  due_date: 'Due Date:',
  item: 'Service Name',
  quantity: 'U.M.',
  unit: 'U.M.',
  price_per_item: 'Quantity',
  amount: 'Value',
  tax: 'VAT (0%)',
  total: 'TURJAN MIHAIL AS872851                                      Total'
}


invoice = InvoicePrinter::Document.new(
  number: invoiced_trip.invoice_id,
  provider_name: 'Ameropa Logistics SRL',
  provider_tax_id:'  RO 32274128',
  provider_tax_id2:'ROONRC.J29/1508/2013 ',
  provider_street: 'sat Cioranii de Jos, Nr. 806, Cod 107160, Comuna Ciorani, Judet Prahova, Romania ',
  provider_street_number: '',
  provider_postcode: '',
  provider_city: '',
  provider_city_part: '',
  provider_extra_address_line: '',
  purchaser_name: client.Name,
  purchaser_tax_id: '',
  purchaser_tax_id2: '',
  purchaser_street: client.Address,
  purchaser_street_number: '',
  purchaser_postcode: '',
  purchaser_city: '',
  purchaser_city_part: '',
  purchaser_extra_address_line: '',
  issue_date: invoiced_trip.date.to_s,
  due_date: (invoiced_trip.date+client.PaymentDelay).to_s,
  subtotal: 'Eur '+invoiced_trip.total_amount.to_s,
  tax: 'Eur 0.00',
  total: 'Eur '+invoiced_trip.total_amount.to_s,

  bank_account_number: 'RO53 RZBR 0000 0600 1753 0734',
  items: [item],
  note: 'Invoice valid in electronic form without stamp and signature'
)


#InvoicePrinter.print(
#  document: invoice,
#  labels: labels,
#  page_size: :a4,
#  file_name:   'wk'.to_s+invoiced_trip.date.strftime("%U").to_s+"_"+
#               client.Name.try(:gsub!,' ', '').to_s+"_"+
#               Truck.find(invoiced_trip.truck_id).NB_PLATE+'.pdf'
#)

respond_to do |format|
    format.pdf {

    send_data InvoicePrinter.render(document: invoice,  labels: labels, page_size: :a4 ), filename: "wk#{invoiced_trip.date.strftime("%U").to_s+
      "_"+ client.Name.try(:gsub!,' ', '').to_s+"_"+ Truck.find(invoiced_trip.truck_id).NB_PLATE}.pdf",  disposition: 'inline' }
 
  end





  end

  # GET /invoiced_trips/new
  def new
    @invoiced_trip = InvoicedTrip.new
  end

  # GET /invoiced_trips/1/edit
  def edit
  end

  # POST /invoiced_trips
  # POST /invoiced_trips.json
  def create
    @invoiced_trip = InvoicedTrip.new(invoiced_trip_params)

    respond_to do |format|
      if @invoiced_trip.save
        format.html { redirect_to @invoiced_trip, notice: 'Invoiced trip was successfully created.' }
        format.json { render :show, status: :created, location: @invoiced_trip }
      else
        format.json { render json: @invoiced_trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoiced_trips/1
  # PATCH/PUT /invoiced_trips/1.json
  def update
    respond_to do |format|
      if @invoiced_trip.update(invoiced_trip_params)
        format.html { redirect_to @invoiced_trip, notice: 'Invoiced trip was successfully updated.' }
        format.json { render :show, status: :ok, location: @invoiced_trip }
      else
        format.html { render :edit }
        format.json { render json: @invoiced_trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoiced_trips/1
  # DELETE /invoiced_trips/1.json
  def destroy
    @invoiced_trip.destroy
    respond_to do |format|
      format.html { redirect_to invoiced_trips_url, notice: 'Invoiced trip was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoiced_trip
      @invoiced_trip = InvoicedTrip.find(params[:id])
      @truck  = Truck.find(@invoiced_trip.truck_id)
      @driver = Driver.find(@invoiced_trip.DRIVER_id)
      @client = Client.find(@invoiced_trip.client_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoiced_trip_params
      params.require(:invoiced_trip).permit(:invoice_id, :date, :StartDate, :EndDate, :client_id, 
        :DRIVER_id, :truck_id, :germany_toll, :belgium_toll, :swiss_toll, :france_toll, 
        :italy_toll, :uk_toll, :netherlands_toll, :km, :km_evogps, :km_driver_route_note, :total_amount)
    end
end
