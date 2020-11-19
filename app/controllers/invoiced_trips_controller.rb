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



    @invoiced_trips = @search.scope_invoiced_trips_index(false)

    @total_loss = @invoiced_trips.sum(&:km) -  @invoiced_trips.sum(&:km_evogps) 

    @total_loss_percentage = 0
    if @invoiced_trips.sum(&:km_evogps) >0
    @total_loss_percentage =  (@total_loss*100)/@invoiced_trips.sum(&:km_evogps)
    end

@invoiced_trips.each_with_index do |invoiced_trip, j|

 @pricing = Pricing.find_by_sql(["SELECT * FROM pricings where pricings.client_id = ? 
  and pricings.DATETIME <= ? order by pricings.DATETIME desc", invoiced_trip.client_id, invoiced_trip.StartDate ]) 

#invoiced_trip.price_per_km = @pricing[0].price_per_km 
#invoiced_trip.surcharge = @pricing[0].surcharge

if @pricing[0] != nil and @pricing[0].price_per_km != nil
  invoiced_trip.update_attribute(:price_per_km, @pricing[0].price_per_km)
end

if  @pricing[0] != nil and @pricing[0].surcharge != nil
   invoiced_trip.update_attribute(:surcharge, @pricing[0].surcharge)
end

end



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


 def index_special
  #  if(current_user.email.eql?  "ameropa.logistics@gmail.com")
  #  @invoiced_trips = InvoicedTrip.all
    @search = TransactionSearch.new(params[:search])



    
    @invoiced_trips = @search.scope_invoiced_trips_index(true)




@invoiced_trips.each_with_index do |invoiced_trip, j|

 @pricing = Pricing.find_by_sql(["SELECT * FROM pricings where pricings.client_id = ? 
  and pricings.DATETIME <= ? order by pricings.DATETIME desc", invoiced_trip.client_id, invoiced_trip.StartDate ]) 

#invoiced_trip.price_per_km = @pricing[0].price_per_km 
#invoiced_trip.surcharge = @pricing[0].surcharge

if @pricing[0] != nil and @pricing[0].price_per_km != nil
  invoiced_trip.update_attribute(:price_per_km, @pricing[0].price_per_km)
end

if  @pricing[0] != nil and @pricing[0].surcharge != nil
   invoiced_trip.update_attribute(:surcharge, @pricing[0].surcharge)
end

end



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
    @invoices = Invoice.all
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
    @invoiced_trip.typeT = 0

  end

   # GET /invoiced_trips/new
  def new_special
    @invoiced_trip = InvoicedTrip.new
    @invoiced_trip.typeT = 1
  end

  # GET /invoiced_trips/1/edit
  def edit
  end


  # POST /invoiced_trips
  # POST /invoiced_trips.json
  def create
  
  @invoiced_trip = InvoicedTrip.new(invoiced_trip_params)
  
  if  @invoiced_trip.brand != nil #_params.fetch(:brand).to_s.size
    @invoiced_trip.StartDate = Invoice.find_by(id: @invoiced_trip.invoice_id).date
    @invoiced_trip.typeT = true
    @invoiced_trip.save
  end

  @pricing = Pricing.find_by_sql(["SELECT * FROM pricings where pricings.client_id = ? 
  and pricings.DATETIME <= ? order by pricings.DATETIME desc", @invoiced_trip.client_id, @invoiced_trip.StartDate ])
  
  if @invoiced_trip.typeT == 0
    @invoiced_trip.surcharge = @pricing[0].surcharge
    @invoiced_trip.price_per_km = @pricing[0].price_per_km
  else
    @invoiced_trip.surcharge = 0
    @invoiced_trip.price_per_km = 0
  end


    if @invoiced_trip.images.count>0
     @invoiced_trip.images.attach(params[:invoiced_trip][:images])
    end

    if @invoiced_trip.bill_of_lading.count>0
     @invoiced_trip.bill_of_lading.attach(params[:invoiced_trip][:images])
    end

    if @invoiced_trip.export_document.count>0
     @invoiced_trip.export_document.attach(params[:invoiced_trip][:images])
    end
    
    respond_to do |format|
      if @invoiced_trip.save
        format.html { redirect_to @invoiced_trip, notice: 'Invoiced trip was successfully created.' }
        format.json { render :show, status: :created, location: @invoiced_trip }
      else
        format.html { render :new }
        format.json { render json: @invoiced_trip.errors, status: :unprocessable_entity }
      end
    end

  end

  def delete_image
     @image = ActiveStorage::Attachment.find(params[:id])
     @image.purge
     redirect_back(fallback_location: invoiced_trips_path)
  end

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

      if @invoiced_trip.typeT == 0
        @truck  = Truck.find(@invoiced_trip.truck_id)
        @driver = Driver.find(@invoiced_trip.DRIVER_id)
        @client = Client.find(@invoiced_trip.client_id)
      else
	@truck  = @invoiced_trip.brand.to_s + " ".to_s + @invoiced_trip.model.to_s + " ".to_s + @invoiced_trip.vin.to_s
        @driver = "".to_s
        @client = Client.find(@invoiced_trip.client_id)
       end      

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoiced_trip_params
      params.require(:invoiced_trip).permit(:invoice_id, :date, :StartDate, :EndDate, :client_id, 
        :DRIVER_id, :truck_id, :info, :germany_toll, :belgium_toll, :swiss_toll, :france_toll, 
        :italy_toll, :uk_toll, :netherlands_toll, :bridge, :parking, :tunnel, :trailer_cost, :km, 
        :km_evogps, :km_driver_route_note, :surcharge, :price_per_km, :total_amount, :typeT,
        :brand, :model, :vin, :production_year, :km_usage, :shipper, images: [] , bill_of_lading: [], export_document: [])
    end
end
