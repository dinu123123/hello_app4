class DriverExpensesController < ApplicationController
  before_action :set_driver, :set_driver_expense, only: [:show, :edit, :update, :destroy]

  # GET /driver_expenses
  # GET /driver_expenses.json
  def index
    @driver_expenses = DriverExpense.all
    @drivers = Driver.all
  end

  # GET /driver_expenses/1
  # GET /driver_expenses/1.json
  def show
  end

  # GET /driver_expenses/new
  def new
    @driver_expense = DriverExpense.new
      end

  # GET /driver_expenses/1/edit
  def edit
  end

  # POST /driver_expenses
  # POST /driver_expenses.json
  def create
    @driver_expense = DriverExpense.new(driver_expense_params)
    respond_to do |format|
      if @driver_expense.save
        format.html { redirect_to @driver_expense, notice: 'Driver expense was successfully created.' }
        format.json { render :show, status: :created, location: @driver_expense }
      else
        format.html { render :new }
        format.json { render json: @driver_expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /driver_expenses/1
  # PATCH/PUT /driver_expenses/1.json
  def update
    respond_to do |format|
      if @driver_expense.update(driver_expense_params)
        format.html { redirect_to @driver_expense, notice: 'Driver expense was successfully updated.' }
        format.json { render :show, status: :ok, location: @driver_expense }
      else
        format.html { render :edit }
        format.json { render json: @driver_expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /driver_expenses/1
  # DELETE /driver_expenses/1.json
  def destroy
    @driver_expense.destroy
    respond_to do |format|
      format.html { redirect_to driver_expenses_url, notice: 'Driver expense was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_driver_expense
      @driver_expense = DriverExpense.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_driver
      @driver_expense = DriverExpense.find(params[:id])
      @driver = Driver.find(@driver_expense.DRIVER_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def driver_params
      params.require(:driver).permit(:FIRST_NAME, :SECOND_NAME)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def driver_expense_params
      params.require(:driver_expense).permit(:DRIVER_id, :DATE, :AMOUNT, :INFO, :DESCRIPTION)
    end
end
