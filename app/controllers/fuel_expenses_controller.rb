class FuelExpensesController < ApplicationController
  before_action :set_fuel_expense, only: [:show, :edit, :update, :destroy]

  # GET /fuel_expenses
  # GET /fuel_expenses.json
  def index
    @fuel_expenses = FuelExpense.all
  end


  def import
    FuelExpense.import(params[:file])
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
      params.require(:fuel_expense).permit( :trstime, :trsdate, :product, :volume, :eurnetamount, 
                                            :kminsertion, :platenr, :cardnr, :stationid, :stationname, 
                                            :eurgrossunitprice, :eurgrossamount, :country, :truck_id)
    end
end
