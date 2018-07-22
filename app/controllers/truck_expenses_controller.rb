class TruckExpensesController < ApplicationController
  before_action :set_truck, :set_truck_expense, only: [:show, :edit, :update, :destroy]

  # GET /truck_expenses
  # GET /truck_expenses.json
  def index
    @truck_expenses = TruckExpense.all
    @trucks = Truck.all
  end

  def main_menus
  end

  # GET /truck_expenses/1
  # GET /truck_expenses/1.json
  def show
  end

  # GET /truck_expenses/new
  def new
    @truck_expense = TruckExpense.new
  end

  # GET /truck_expenses/1/edit
  def edit
  end

  # POST /truck_expenses
  # POST /truck_expenses.json
  def create
    @truck_expense = TruckExpense.new(truck_expense_params)

    respond_to do |format|
      if @truck_expense.save
        format.html { redirect_to @truck_expense, notice: 'Truck expense was successfully created.' }
        format.json { render :show, status: :created, location: @truck_expense }
      else
        format.html { render :new }
        format.json { render json: @truck_expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /truck_expenses/1
  # PATCH/PUT /truck_expenses/1.json
  def update
    respond_to do |format|
      if @truck_expense.update(truck_expense_params)
        format.html { redirect_to @truck_expense, notice: 'Truck expense was successfully updated.' }
        format.json { render :show, status: :ok, location: @truck_expense }
      else
        format.html { render :edit }
        format.json { render json: @truck_expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /truck_expenses/1
  # DELETE /truck_expenses/1.json
  def destroy
    @truck_expense.destroy
    respond_to do |format|
      format.html { redirect_to truck_expenses_url, notice: 'Truck expense was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_truck_expense
      @truck_expense = TruckExpense.find(params[:id])
    end

 # Use callbacks to share common setup or constraints between actions.
    def set_truck
     @truck_expense = TruckExpense.find(params[:id])
     @truck = Truck.find(@truck_expense.truck_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def truck_params
      params.require(:truck).permit(:NB_PLATE, :INFO)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def truck_expense_params
      params.require(:truck_expense).permit(:truck_id, :DATE, :AMOUNT, :INFO, :DESCRIPTION)
    end
end
