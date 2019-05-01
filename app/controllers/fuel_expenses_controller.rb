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
      fuelexpense.update_attribute(:eurnetamount, fuelexpense.eurnetamount) #this persists the entities to the DB

      end

      if fuelexpense.country== "DEU"
        fuelexpense.EuroNetAmountInclVATFreeCharges = (fuelexpense.eurgrossamount/(1+@DEUVAT))+(fuelexpense.eurgrossamount- (fuelexpense.eurgrossamount/(1+@DEUVAT)))  *@DEUVAT_FREE_CHARGES

        fuelexpense.eurnetamount = (fuelexpense.eurgrossamount/(1+@DEUVAT))
      fuelexpense.update_attribute(:eurnetamount, fuelexpense.eurnetamount) #this persists the entities to the DB

      end

      if fuelexpense.country== "NLD"
        fuelexpense.EuroNetAmountInclVATFreeCharges = (fuelexpense.eurgrossamount/(1+@NLDVAT))+(fuelexpense.eurgrossamount-  (fuelexpense.eurgrossamount/(1+@NLDVAT)) )  *@NLDVAT_FREE_CHARGES

        fuelexpense.eurnetamount = (fuelexpense.eurgrossamount/(1+@NLDVAT))
      fuelexpense.update_attribute(:eurnetamount, fuelexpense.eurnetamount) #this persists the entities to the DB

      end

      fuelexpense.update_attribute(:EuroNetAmountInclVATFreeCharges, fuelexpense.EuroNetAmountInclVATFreeCharges) #this persists the entities to the DB

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
