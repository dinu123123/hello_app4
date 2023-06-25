class FuelExpensesController < ApplicationController
  before_action :set_fuel_expense, only: [:show, :edit, :update, :destroy]

  # GET /fuel_expenses
  # GET /fuel_expenses.json
  def index



FuelExpense.all.each_with_index do |fuelexpense,i|
 
if false
 @BELVAT_FREE = false
    @BELVAT_FREE_CHARGES = "0.07".to_d
    @BELVAT = "0.21".to_d

    @DEUVAT_FREE = true
    @DEUVAT_FREE_CHARGES = "0.055".to_d
    @DEUVAT = "0.19".to_d

    @NLDVAT_FREE = true
    @NLDVAT_FREE_CHARGES = "0.055".to_d  
    @NLDVAT = "0.21".to_d


      fuelexpense.EuroNetAmountInclVATFreeCharges = fuelexpense.eurnetamount+fuelexpense.volume*0.0152
     
      if fuelexpense.country== "BEL"
        fuelexpense.EuroNetAmountInclVATFreeCharges = (fuelexpense.eurgrossamount/(1+@BELVAT))+(fuelexpense.eurgrossamount - (fuelexpense.eurgrossamount/(1+@BELVAT))  )*@BELVAT_FREE_CHARGES

        fuelexpense.eurnetamount = (fuelexpense.eurgrossamount/(1+@BELVAT))
      fuelexpense.update_attribute(:eurnetamount, fuelexpense.eurnetamount.round(2)) #this persists the entities to the DB

      end

      if fuelexpense.country== "DEU"
        fuelexpense.EuroNetAmountInclVATFreeCharges = (fuelexpense.eurgrossamount/(1+@DEUVAT))+(fuelexpense.eurgrossamount- (fuelexpense.eurgrossamount/(1+@DEUVAT)))  *@DEUVAT_FREE_CHARGES

        fuelexpense.eurnetamount = (fuelexpense.eurgrossamount/(1+@DEUVAT))
      fuelexpense.update_attribute(:eurnetamount, fuelexpense.eurnetamount.round(2)) #this persists the entities to the DB

      end

      if fuelexpense.country== "NLD"
        fuelexpense.EuroNetAmountInclVATFreeCharges = (fuelexpense.eurgrossamount/(1+@NLDVAT))+(fuelexpense.eurgrossamount-  (fuelexpense.eurgrossamount/(1+@NLDVAT)) )  *@NLDVAT_FREE_CHARGES

        fuelexpense.eurnetamount = (fuelexpense.eurgrossamount/(1+@NLDVAT))
      fuelexpense.update_attribute(:eurnetamount, fuelexpense.eurnetamount.round(2)) #this persists the entities to the DB

      end

      fuelexpense.update_attribute(:EuroNetAmountInclVATFreeCharges, fuelexpense.EuroNetAmountInclVATFreeCharges.round(2)) #this persists the entities to the DB

  end

  #the code here is called once for each user
  # user is accessible by 'user' variable
end


    @fuel_expenses = FuelExpense.all
    respond_to do |format|
        format.html
        format.csv { send_data @fuel_expenses.to_csv, filename: "fuel_expenses-#{Time.now.strftime('s%S/m%M/h%H/')+Date.today.strftime('d%d/m%m/y%Y')}.csv" }   
        format.xls #{ send_data @trucks.to_csv(col_sep: "\t") }
      end
  end


  def import
    FuelExpense.import(params[:file])
    redirect_to fuel_expenses_url, notice: "Activity Data Imported!"
  end 

  def import_as24
    FuelExpense.import_as24(params[:file])
    redirect_to fuel_expenses_url, notice: "Activity Data Imported!"
  end 

  def parsed_active (n1, default)
    if n1 == nil
      return 0
    else
      return 1  
    end
  end

  def import_dkv
    import_dkv_file(params[:file], parsed_active(params[:date_format_month_day_year], 1))
    #redirect_to fuel_expenses_url, notice: "Activity Data Imported!"
  end 

def import_dkv_file(file, date_format_month_day_year)
   
# TruckExpense.delete_all; FuelExpense.delete_all; DeToll.delete_all; GenericToll.delete_all; DriverExpense.delete_all

## this is used to count the line numbers within the file
lines_end_to_skip = CSV.read(file.path,  headers: [
'Vehicle registration number',
'Number of card or box',
'Billing date',
'Date',
'Customer number',
'Sales',
'Unit',
'Value of purchases net',
'Value of purchases gross',
'Product code',
'Product',
'Product group',
'Cost centre',
'Card -additional information',
'Service country',
'Price per unit',
'VAT',
'Discount net',
'Discount gross',
'Service fee net',
'Service fee gross',
'Postcode',
'Town',
'Service station',
'Brand',
'AB',
'AH',
'Mileage in km',
'Customized data 1',
'OBU ID'],
     encoding: "ISO-8859-1",  
                               :col_sep => ";", 
                               :quote_char => "\"", 
                               :header_converters => lambda { |h| h.try(:gsub,' ', ' ').try(:gsub,'ï»¿', '') }
                    ).count-3

row_to_skip = 0

CSV.foreach(file.path,  headers: [
'Vehicle registration number',
'Number of card or box',
'Billing date',
'Date',
'Customer number',
'Sales',
'Unit',
'Value of purchases net',
'Value of purchases gross',
'Product code',
'Product',
'Product group',
'Cost centre',
'Card -additional information',
'Service country',
'Price per unit',
'VAT',
'Discount net',
'Discount gross',
'Service fee net',
'Service fee gross',
'Postcode',
'Town',
'Service station',
'Brand',
'AB',
'AH',
'Mileage in km',
'Customized data 1',
'OBU ID'],
     encoding: "ISO-8859-1",  
                               :col_sep => ";", 
                               :quote_char => "\"", 
                               :header_converters => lambda { |h| h.try(:gsub,' ', ' ').try(:gsub,'ï»¿', '') }
                    ).with_index do |row, index| 
   next if index < 12 or index >= lines_end_to_skip


##    if row_to_skip ==0
##        row_to_skip = 1
##    else  
      @my_date = row["Date"]

    @my_product = row["Product"].to_s.try(:gsub,' ', ' ')
    @my_volume = row["Sales"].to_s.try(:gsub,',','').to_d
    @my_country = row["Service country"].to_s.try(:gsub,' ', '')

    if row["Mileage in km"] != nil
      @my_kminsertion = row["Mileage in km"].to_s.try(:gsub,',','').to_d
    else
      @my_kminsertion = 0.to_d
    end

    @my_truck = row["Vehicle registration number"].to_s.try(:gsub,' ', '').try(:gsub,'-', '') 
    @my_cardnr = row["Number of card or box"].to_s.try(:gsub,' ', '')
    @my_stationid = row["Site_nbr"].to_s.try(:gsub,' ', '')
    @my_stationname = row["Town"].to_s.try(:gsub,' ', '')
    @my_eurgrossunitprice = 0.to_d

    if row["Value of purchases gross"] != nil
      @my_eurgrossamount = row["Value of purchases gross"].to_s.try(:gsub,',','').to_d
    else
      @my_eurgrossamount = 0.to_d
    end

   if @my_truck == " "
      @my_truck_id =  23
      @my_platenr = "Office".to_s
   else
      @my_truck_id_ROW = Truck.find_by NB_PLATE:@my_truck.try(:gsub,' ', '')
      if @my_truck_id_ROW == nil
        @my_truck_id =  23
        @my_platenr = "Office".to_s
      else
        @my_truck_id = @my_truck_id_ROW.id
      end
   end

   @my_row = Hash.new
   logger.debug @my_date

   if date_format_month_day_year == 1
      @my_trstime = DateTime.strptime( @my_date.try(:gsub,'.', '/'), '%m/%d/%Y %H:%M')
   else
      @my_trstime = DateTime.strptime( @my_date.try(:gsub,'.', '/'), '%d/%m/%Y %H:%M')
   end

   if @my_trstime.year < 50
      year4 = "20" + @my_trstime.year.to_s
   elsif @my_trstime.year >= 50 and @my_trstime.year < 100
      year4 = "19" + @my_trstime.year.to_s
   else
      year4 = @my_trstime.year.to_s
   end

   @my_trsdatetime = DateTime.new(year4.to_i, @my_trstime.month, @my_trstime.day, @my_trstime.hour , @my_trstime.minute, 0.to_i, DateTime.now.zone)
   @my_trsdate = @my_trsdatetime.to_time

   @my_eur = row["Value of purchases net"].try(:gsub,',', '').to_s.to_d - 
             row["Discount net"].try(:gsub,',', '').to_s.to_d + 
             row["Service fee net"].try(:gsub,',', '').to_s.to_d


if @my_product == "Toll D - DKV BOX EUROPE"

   @my_platenr = row["Vehicle registration number"].to_s.try(:gsub,' ', '').try(:gsub,'-', '')

   @my_date = @my_trsdatetime.to_date
   @my_time = "12:00".to_time
   @my_datetime = @my_date.to_s+ "T" + @my_time.to_s
   @my_row = @my_row.to_a<<(["datetime",@my_datetime]) 

   @my_bookingid = "0".to_s 
   @my_art = "0".to_s
   @my_road = "".to_s
   @my_via = "".to_s
   @my_departure = "".to_s
   @my_costcentre = "0".to_i
      
   @my_tariffmodel = "0".to_i
   @my_axelclass = "0".to_i
   @my_weightclass = "0".to_i
   @my_emissioncat = "0".to_i
   @my_roadoperators = "0".to_i

   @my_ver = "-".to_s
   @my_km = "0".to_d
   #@my_eur = @my_eurgrossamount

   @my_row = @my_row.to_a<<(["platenr",@my_platenr])<<(["date",@my_date])<<(["time",@my_time])
   @my_row = @my_row.to_a<<(["bookingid",@my_bookingid])<<(["art",@my_art])<<(["road",@my_road])

   @my_row = @my_row.to_a<<(["via",@my_via])<<(["art",@art])<<(["road",@my_road]) 
   @my_row = @my_row.to_a<<(["eur",@my_eur])<<(["truck_id",@my_truck_id])
   @my_row = @my_row.to_a<<(["manual",false]) 

   DeToll.find_or_create_by @my_row.to_h

elsif @my_product.start_with?('Toll') or @my_product.include?('DKV BOX EUROPE')

  
   @my_date = @my_trsdatetime.to_date
   @my_time = "12:00".to_time

   @my_datetime = @my_date.to_s+ "T" + @my_trsdatetime.to_time.to_s
   @my_row = @my_row.to_a<<(["StartDate",@my_datetime]) 
   @my_row = @my_row.to_a<<(["EndDate",@my_datetime]) 

   @my_km = row["Mileage in km"].to_s.to_i
   @my_row = @my_row.to_a<<(["Km",@my_km]) 
   @my_net_costs = @my_eur 
   @my_row = @my_row.to_a<<(["EUR",@my_net_costs]) 

   @my_row = @my_row.to_a<<(["truck_id",@my_truck_id]) 
   @my_row = @my_row.to_a<<(["country",@my_country]) 
   @my_row = @my_row.to_a<<(["manual",false]) 
   GenericToll.find_or_create_by @my_row.to_h

elsif @my_product == "DIESEL" or @my_product == "diesel" or @my_product.include?('ADBLUE')  or @my_product.include?('adblue') or @my_product.include?("AD BLUE")  or @my_product.include?("ad blue") 

      @my_row = Hash.new
      @my_row = @my_row.to_a<<(["trstime",@my_trsdatetime.to_time])
      @my_row = @my_row.to_a<<(["trsdate",@my_trsdatetime.to_date])
      @my_row = @my_row.to_a<<(["product",@my_product])
      @my_row = @my_row.to_a<<(["volume",@my_volume])
      @my_row = @my_row.to_a<<(["kminsertion",@my_kminsertion])
      @my_row = @my_row.to_a<<(["platenr",@my_truck])
      @my_row = @my_row.to_a<<(["cardnr",@my_cardnr])
      @my_row = @my_row.to_a<<(["stationid",@my_stationid])
      @my_row = @my_row.to_a<<(["stationname",@my_stationname])
      @my_row = @my_row.to_a<<(["eurgrossunitprice",@my_eurgrossunitprice])
      @my_row = @my_row.to_a<<(["eurgrossamount",@my_eurgrossamount])
      @my_row = @my_row.to_a<<(["country",@my_country])
      @my_row = @my_row.to_a<<(["truck_id",@my_truck_id])

      #default
      @my_eurnetamount = @my_eur
      @my_EuroNetAmountInclVATFreeCharges = @my_eur
    
      @my_row = @my_row.to_a<<(["eurnetamount",@my_eurnetamount.to_d.round(2)])
      @my_row = @my_row.to_a<<(["EuroNetAmountInclVATFreeCharges",@my_EuroNetAmountInclVATFreeCharges.round(2)])
      
      @my_row_datetime =@my_trsdate.to_s + "T" + @my_trstime.to_s

            if @my_truck != nil 

              if  @my_eurgrossamount > 0.to_d
                 #do not register transactions with zero value 
                 @my_row = @my_row.to_a<<(["truck_id",@my_truck_id]) 
                 @my_row = @my_row.to_a<<(["datetime",@my_row_datetime]) 
                 FuelExpense.find_or_create_by @my_row.to_h
               end
            else
              #hope one day we will have 1001 trucks
              #but then that wont be a problem 
              @my_row = @my_row.to_a<<(["truck_id",23.to_i]) 
              #@my_row_datetime = row.to_a[1][1].try(:gsub!,'/', '-')+ "T" + row.to_a[0][1]
              @my_row = @my_row.to_a<<(["datetime",@my_row_datetime]) 
              FuelExpense.find_or_create_by @my_row.to_h
            end 
       
    
else 
  
   @my_platenr = row["Vehicle registration number"].to_s.try(:gsub,' ', '').try(:gsub,'-', '')
   @my_date = @my_trsdatetime
   @my_row = @my_row.to_a<<(["DATE",@my_date]) 
   @my_row = @my_row.to_a<<(["AMOUNT",@my_eur]) 
   @my_row = @my_row.to_a<<(["truck_id",@my_truck_id]) 
   @my_row = @my_row.to_a<<(["DESCRIPTION", (row["Product"].to_s.try(:gsub,' ', ' ')+ row["Product group"].to_s.try(:gsub,' ', ' ')+ @my_country) ])
   @my_row = @my_row.to_a<<(["manual",false]) 
   TruckExpense.find_or_create_by @my_row.to_h

  end

end

##end









end



  # GET /fuel_expenses/1
  # GET /fuel_expenses/1.json
  def show
  end

  # GET /fuel_expenses/new
  def new
    @fuel_expense = FuelExpense.new
  end

  # GET /fuel_expenses/1/edit
  def edit
  end

  # POST /fuel_expenses
  # POST /fuel_expenses.json
  def create
    @fuel_expense = FuelExpense.new(fuel_expense_params)

    respond_to do |format|
      if @fuel_expense.save
        format.html { redirect_to @fuel_expense, notice: 'Fuel expense was successfully created.' }
        format.json { render :show, status: :created, location: @fuel_expense }
      else
        format.html { render :new }
        format.json { render json: @fuel_expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fuel_expenses/1
  # PATCH/PUT /fuel_expenses/1.json
  def update
    respond_to do |format|
      if @fuel_expense.update(fuel_expense_params)
        format.html { redirect_to @fuel_expense, notice: 'Fuel expense was successfully updated.' }
        format.json { render :show, status: :ok, location: @fuel_expense }
      else
        format.html { render :edit }
        format.json { render json: @fuel_expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fuel_expenses/1
  # DELETE /fuel_expenses/1.json
  def destroy
    @fuel_expense.destroy
    respond_to do |format|
      format.html { redirect_to fuel_expenses_url, notice: 'Fuel expense was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fuel_expense
      @fuel_expense = FuelExpense.find(params[:id])
    end
        

    # Never trust parameters from the scary internet, only allow the white list through.
    def fuel_expense_params
      params[:fuel_expense][:platenr] = Truck.all.find(params[:fuel_expense][:truck_id]).NB_PLATE
      params.require(:fuel_expense).permit( :trstime, :trsdate, :product, :volume, :eurnetamount, :EuroNetAmountInclVATFreeCharges,
                                            :kminsertion, :platenr, :cardnr, :stationid, :stationname, 
                                            :eurgrossunitprice, :eurgrossamount, :country, :truck_id)
    
    end

  end


