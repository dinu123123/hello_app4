class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

attr_accessor :total_price_calculated

  # GET /invoices
  # GET /invoices.json
  def index
    @total_price = 0
    @search = TransactionSearch.new(params[:search])
    @invoices = @search.scope_invoices_index
    @total_price = @invoices.sum(&:total_amount)
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


def email()
  file = print (true)
  @invoice = Invoice.find(params[:id])
  client = Client.find(@invoice.client_id)

 

  if !InvoiceMailer.invoice_email(client.email, file, @invoice).deliver
      redirect_to @invoice
  else 
    @invoice.sent = true
    @invoice.save
    redirect_back fallback_location: root_path and return @invoice
  end
end

def print(send_invoice=false)


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




ary = Array.new

@total_price_calculated = 0

@sum_individual_invoices = 0

invoice_trip_all.each {
 |a| 


client = Client.find(a.client_id)


if invoiced_trip.typeT == 1 or a.DRIVER_id == nil
 driver = Driver.all.find_by_SECONDNAME("Turjan")
else
 driver = Driver.all.find(a.DRIVER_id)
end



if invoiced_trip.typeT == 1 or a.truck_id == nil
 truck = Truck.all.find_by_NB_PLATE("Office")
else
 truck = Truck.all.find(a.truck_id)
end




@sum_individual_invoices += a.total_amount.to_s.to_c


@price_distance = 0
if client.kprice>0 and (invoiced_trip.typeT == 0 or invoiced_trip.typeT == nil)
  @price_distance = a.km*a.price_per_km
else
  @price_distance = a.total_amount
end


@info = ""

if a.info != nil and a.info.length >0
  @info = a.info
else 
  @info = invoice.info
end

@service_name = ""

if a.info !=nil and invoice.info != a.info
  @service_name = invoice.info
end

if @service_name.length>0
 @service_name = " - " + @service_name
end



if invoiced_trip.typeT == 1

item = InvoicePrinter::Document::Item.new(
  name: "VIN " + invoiced_trip.vin.to_s,
  tax: (invoice.vat/100*invoice.total_amount).round(2).to_s,
  amount: invoice.total_amount.to_s
)
@total_price_calculated += 100

ary << item

else

item = InvoicePrinter::Document::Item.new(
  name: @info+"  "+truck.NB_PLATE+" / "+ driver.FIRSTNAME.to_s+" "+driver.SECONDNAME.to_s, #+invoiced_trip.date.strftime("%U").to_s+" ".to_s+Truck.find(invoiced_trip.truck_id).NB_PLATE,
  unit: a.price_per_km,
  quantity: "km".to_s,
  price: a.km,
  tax: (invoice.vat/100*@price_distance.round(2)).round(2).to_s,
  amount: @price_distance.round(2) # client_id.price_per_km,
)

@total_price_calculated += a.km*a.price_per_km
ary << item

#in case surcharge applies
if (a.surcharge > 0)
  item = InvoicePrinter::Document::Item.new(
    name: @info+"  "+truck.NB_PLATE+"/ Diesel Surcharge = "+ a.surcharge.to_s+ "%", #+invoiced_trip.date.strftime("%U").to_s+" ".to_s+Truck.find(invoiced_trip.truck_id).NB_PLATE,
    unit: "1".to_s,
    quantity: "piece".to_s,
    price: 1,
    amount: (@price_distance*a.surcharge/100).round(2), # client_id.price_per_km,
    tax: '0'  
  )

  @total_price_calculated += (@price_distance*a.surcharge/100)
  ary << item
end

if (a.germany_toll > 0)
    item = InvoicePrinter::Document::Item.new(
      name: @info+"  "+truck.NB_PLATE+" / "+'Germany Toll Road'.to_s, #+invoiced_trip.date.strftime("%U").to_s+" ".to_s+Truck.find(invoiced_trip.truck_id).NB_PLATE,
      unit:  a.germany_toll.round(2),
      quantity: "piece".to_s,
      price: '1',
      amount: a.germany_toll.round(2), # client_id.price_per_km,
      tax: '0')
    ary << item

    @total_price_calculated +=a.germany_toll

end

if (a.belgium_toll > 0)
    item = InvoicePrinter::Document::Item.new(
      name: @info+"  "+truck.NB_PLATE+" / "+'Belgium Toll Road'.to_s, #+invoiced_trip.date.strftime("%U").to_s+" ".to_s+Truck.find(invoiced_trip.truck_id).NB_PLATE,
      unit: a.belgium_toll.round(2),
      quantity: "piece".to_s,
      price: '1',
      amount: a.belgium_toll.round(2), # client_id.price_per_km,
      tax: '0')
    ary << item

    @total_price_calculated +=a.belgium_toll

end

if (a.swiss_toll > 0)
    item = InvoicePrinter::Document::Item.new(
      name: @info+"  "+truck.NB_PLATE+" / "+'Swiss Toll Road'.to_s, #+invoiced_trip.date.strftime("%U").to_s+" ".to_s+Truck.find(invoiced_trip.truck_id).NB_PLATE,
      unit:  a.swiss_toll.round(2),
      quantity: "piece".to_s,
      price: '1',
      amount: a.swiss_toll.round(2), # client_id.price_per_km,
      tax: '0')
    ary << item

    @total_price_calculated +=a.swiss_toll

end


if (a.france_toll > 0)
    item = InvoicePrinter::Document::Item.new(
      name: @info+"  "+truck.NB_PLATE+" / "+'France Toll Road'.to_s, #+invoiced_trip.date.strftime("%U").to_s+" ".to_s+Truck.find(invoiced_trip.truck_id).NB_PLATE,
      unit: a.france_toll.round(2),
      quantity: "piece".to_s,
      price: '1',
      amount: a.france_toll.round(2), # client_id.price_per_km,
      tax: '0')

    @total_price_calculated +=a.france_toll

    ary << item
end


if (a.italy_toll > 0)
    item = InvoicePrinter::Document::Item.new(
      name: @info+"  "+truck.NB_PLATE+" / "+'Italy Toll Road'.to_s, #+invoiced_trip.date.strftime("%U").to_s+" ".to_s+Truck.find(invoiced_trip.truck_id).NB_PLATE,
      unit: a.italy_toll.round(2),
      quantity: "piece".to_s,
      price: '1',
      amount: a.italy_toll.round(2), # client_id.price_per_km,
      tax: '0')
    ary << item

    @total_price_calculated +=a.italy_toll

end


if (a.uk_toll > 0)
    item = InvoicePrinter::Document::Item.new(
      name: @info+"  "+truck.NB_PLATE+" / "+'United Kingdom Toll Road'.to_s, #+invoiced_trip.date.strftime("%U").to_s+" ".to_s+Truck.find(invoiced_trip.truck_id).NB_PLATE,
      unit:  a.uk_toll.round(2),
      quantity: "piece".to_s,
      price: '1',
      amount: a.uk_toll.round(2), # client_id.price_per_km,
      tax: '0')
    ary << item
    @total_price_calculated +=a.uk_toll
end


if (a.netherlands_toll > 0)
    item = InvoicePrinter::Document::Item.new(
      name: @info+"  "+truck.NB_PLATE+" / "+'The Netherlands Toll Road'.to_s, #+invoiced_trip.date.strftime("%U").to_s+" ".to_s+Truck.find(invoiced_trip.truck_id).NB_PLATE,
      unit: a.netherlands_toll.round(2),
      quantity: "piece".to_s,
      price: '1',
      amount: a.netherlands_toll.round(2), # client_id.price_per_km,
      tax: '0')
    ary << item
    @total_price_calculated +=a.netherlands_toll
end


if (a.bridge != nil and a.bridge > 0)
    item = InvoicePrinter::Document::Item.new(
      name: @info+"  "+truck.NB_PLATE+" / "+'Bridge crossing costs'.to_s, #+invoiced_trip.date.strftime("%U").to_s+" ".to_s+Truck.find(invoiced_trip.truck_id).NB_PLATE,
      unit: a.bridge.round(2),
      quantity: "piece".to_s,
      price: '1',
      amount: a.bridge.round(2), # client_id.price_per_km,
      tax: '0')
    ary << item
    @total_price_calculated +=a.bridge
end

if (a.parking != nil and a.parking > 0)
    item = InvoicePrinter::Document::Item.new(
      name: @info+"  "+truck.NB_PLATE+" / "+'Parking Costs'.to_s, #+invoiced_trip.date.strftime("%U").to_s+" ".to_s+Truck.find(invoiced_trip.truck_id).NB_PLATE,
      unit: a.parking.round(2),
      quantity: "piece".to_s,
      price: '1',
      amount: a.parking.round(2), # client_id.price_per_km,
      tax: '0')
    ary << item
    @total_price_calculated +=a.parking
end

if (a.tunnel != nil and a.tunnel > 0)
    item = InvoicePrinter::Document::Item.new(
      name: @info+"  "+truck.NB_PLATE+" / "+'Tunnel Costs'.to_s, #+invoiced_trip.date.strftime("%U").to_s+" ".to_s+Truck.find(invoiced_trip.truck_id).NB_PLATE,
      unit: a.tunnel.round(2),
      quantity: "piece".to_s,
      price: '1',
      amount: a.tunnel.round(2), # client_id.price_per_km,
      tax: '0')
    ary << item
    @total_price_calculated +=a.tunnel
end

if (a.trailer_cost != nil and a.trailer_cost > 0)
    item = InvoicePrinter::Document::Item.new(
      name: @info+"  "+truck.NB_PLATE+" / "+'Trailer Rental Costs'.to_s, #+invoiced_trip.date.strftime("%U").to_s+" ".to_s+Truck.find(invoiced_trip.truck_id).NB_PLATE,
      unit: -a.trailer_cost.round(2),
      quantity: "piece".to_s,
      price: '1',
      amount: -a.trailer_cost.round(2), # client_id.price_per_km,
      tax: '0')
    ary << item
    @total_price_calculated -=a.trailer_cost
end
end


}

client = Client.find(invoice.client_id)

item = InvoicePrinter::Document::Item.new(
  name: 'Transport '.to_s + @info, #+invoiced_trip.date.strftime("%U").to_s+" ".to_s+Truck.find(invoiced_trip.truck_id).NB_PLATE,
  unit: "1".to_s,
  quantity: "piece".to_s,
  price: '1',
  amount: invoice.total_amount.round(2),
  tax: '0'  
)

if invoiced_trip.typeT == 0 or invoiced_trip.typeT == nil

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
  item: 'Service Name'+ @service_name,
  unit: 'Unit price',
  quantity: 'U.O.M.',
  price_per_item: 'Quantity',
  amount: 'Value (€)',
  tax: 'VAT (' + invoice.vat.to_s + '%)',
  total: 'TURJAN MIHAIL AS872851                                      Total'
}

else

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
  item: invoiced_trip.brand.to_s + " ".to_s  + invoiced_trip.model.to_s,
  unit: 'Unit price',
  quantity: 'U.O.M.',
  price_per_item: 'VIN',
  amount: 'Value (€)',
  tax: 'VAT (' + invoice.vat.to_s + '%)',
  total: 'TURJAN MIHAIL AS872851                                      Total'
}

end


invoice_inline = InvoicePrinter::Document.new(
  number: invoice.name,
  provider_name: 'Ameropa Logistics SRL',
  provider_tax_id:'  RO32274128',
  provider_tax_id2:'ROONRC.J29/1508/2013 ',
  provider_street: 'Cioranii de Jos, Nr. 806, Cod 107160                                                                      Comuna Ciorani                                                                          Judet Prahova                                                Romania ',
  provider_street_number: '',
  provider_postcode: '',
  provider_city: '',
  provider_city_part: '',
  provider_extra_address_line: '',
  purchaser_name: client.Name,
  purchaser_tax_id: '',
  purchaser_tax_id2: '',
  purchaser_street: "\n".to_s + client.Address,
  purchaser_street_number: '',
  purchaser_postcode: '',
  purchaser_city: '',
  purchaser_city_part: '',
  purchaser_extra_address_line: '',
  issue_date: invoice.date.to_s,
  due_date: (invoice.date+client.PaymentDelay).to_s,
  subtotal: '€ '+invoice.total_amount.round(2).to_s,
  tax: '€ '+ (invoice.vat/100*invoice.total_amount).round(2).to_s,
  total: '€ '+(invoice.total_amount*((100+invoice.vat)/100)).round(2).to_s,

  bank_account_number: 'RO53 RZBR 0000 0600 1753 0734',
  items: ary,
  note: 'This is computer generated invoice. No signature required.'
)

  #if (@total_price_calculated - invoice.total_amount).abs<5 

  # @total_price_calculated - the sum of client_price_per_km times nb_of_km plus toll_costs
  # invoice.total_amount - the total invoice amount
  # sum_individual_invoices - the sum of the individual trips amount

  if (invoice.total_amount -  @sum_individual_invoices).abs < 3 or invoiced_trip.typeT == 1
   

    if(!send_invoice)
      invoice.printed = true
      invoice.save
      respond_to do |format|
        format.pdf {
        send_data InvoicePrinter.render(document: invoice_inline,  labels: labels, page_size: :a4 ), filename: invoice.info+
          "_"+ client.Name.try(:gsub!,' ', '').to_s+".pdf",  disposition: 'inline' }
      end
         
    end

    localObj = Struct.new(:file, :name, :invoiceName, :invoiceTrip)
    return localObj.new(InvoicePrinter.render(document: invoice_inline,  labels: labels, page_size: :a4), 
                    "AmeropaLogistics_"+invoice.info+"_"+ client.Name.try(:gsub!,' ', '').to_s+".pdf",invoice.name ,invoice.info )

  else

if invoiced_trip.typeT == 0 or invoiced_trip.typeT == nil
    if @total_price_calculated > 0
        render html: "<script>alert('The invoiced amount different than the sum of the component trips!')</script>".to_s.html_safe +
        "<b>".to_s.html_safe + invoice.total_amount.to_s + " €</b>".to_s.html_safe + " - the total amout invoiced (suma totala facturata): ".to_s + "<p>".to_s.html_safe + 
        "<b>".to_s.html_safe +  @sum_individual_invoices.to_s.html_safe + " €</b>".to_s.html_safe + " - the sum of the individal trips (suma tripurilor individuale) ".to_s +
        "</p>".to_s.html_safe +  " <p>".to_s.html_safe + "<b>".to_s.html_safe + @total_price_calculated.to_s + " €</b>".to_s.html_safe + " - the sum of the individual trips CALCULATED using price/km (Suma tripurilor individuale CALCULATE ca folosind pret/km) ".to_s + "</p>".to_s.html_safe 
    else
        render html: "<script>alert('The invoiced amount different than the sum of the component trips!')</script>".to_s.html_safe +
        "<b>".to_s.html_safe + client.Name.to_s.html_safe + " is a fix rate client.".to_s.html_safe + "<p>".to_s.html_safe + 
        "<b>".to_s.html_safe + invoice.total_amount.to_s + " €</b>".to_s.html_safe + " - the sum of the individal trips (suma tripurilor individuale) ".to_s + 
        "</p>".to_s.html_safe +  "<p>".to_s.html_safe + "<b>".to_s.html_safe +  @sum_individual_invoices.to_s.html_safe + " €</b>".to_s.html_safe + " - the sum of the individual trips CALCULATED using price/km (Suma tripurilor individuale CALCULATE ca folosind pret/km) ".to_s + "</p>".to_s.html_safe
    end
end   
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
      params.require(:invoice).permit(:name, :info, :date, :client_id, :vat, :total_amount, :sent, :printed, :paid)
    end

end
