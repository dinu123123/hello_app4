class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

  # GET /invoices
  # GET /invoices.json
  def index



    @search = TransactionSearch.new(params[:search])
    
    @invoices = @search.scope_invoices_index


    
    #@invoices = Invoice.all
    #@invoices = Invoice.find_by_sql(['SELECT * FROM invoices ORDER BY  invoices.date DESC, invoices.client_id ASC, invoices.info DESC '])
    @clients = Client.all
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to action: "index" }
        #format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        #format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to invoices_url, notice: 'Invoice was successfully destroyed.' }
      format.json { head :no_content }
    end
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

invoice = Invoice.find(params[:id])
invoice_trip_all = InvoicedTrip.find_by_sql(['SELECT * FROM invoiced_trips WHERE invoiced_trips.invoice_id = ? ', invoice.id])
invoiced_trip = invoice_trip_all[0]

client = Client.find(invoice.client_id)

total_amount = 0
invoice_trip_all.each { |a| total_amount+=a.total_amount }


item = InvoicePrinter::Document::Item.new(
  name: 'Transport '.to_s + invoice.info, #+invoiced_trip.date.strftime("%U").to_s+" ".to_s+Truck.find(invoiced_trip.truck_id).NB_PLATE,
  quantity: nil,
  unit: "piece".to_s,
  price: '1',
  amount: invoice.total_amount,
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


invoice_inline = InvoicePrinter::Document.new(
  number: invoice.name,
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
  issue_date: invoice.date.to_s,
  due_date: (invoice.date+client.PaymentDelay).to_s,
  subtotal: 'Eur '+invoice.total_amount.to_s,
  tax: 'Eur 0.00',
  total: 'Eur '+invoice.total_amount.to_s,

  bank_account_number: 'RO53 RZBR 0000 0600 1753 0734',
  items: [item],
  note: 'Invoice valid in electronic form without stamp and signature'
)


respond_to do |format|
    format.pdf {

    send_data InvoicePrinter.render(document: invoice_inline,  labels: labels, page_size: :a4 ), filename: invoice.info+
      "_"+ client.Name.try(:gsub!,' ', '').to_s+".pdf",  disposition: 'inline' }
 
  end





  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
      @client = Client.find(@invoice.client_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
      params.require(:invoice).permit(:name, :info, :date, :client_id, :vat, :total_amount)
    end

end
