class DriverExpensesController < ApplicationController
  before_action :set_driver, :set_driver_expense, only: [:show, :edit, :update, :destroy]

  def import
    DriverExpense.import(params[:file])
    redirect_to driver_expenses_url, notice: "Activity Data Imported!"
  end


def event_to_date (date)
  if date.to_s.include? "T" and ! (date.to_s.include? "U" )
     Date.parse(date).strftime('%Y-%m-%d').to_date
  else
    #Time.parse(date).strftime('2000-01-01 %H:%M:00')  
    Date.parse(date).to_date
  end
end

  # GET /drivers
  # GET /drivers.json
  def index

    @search = TransactionSearch.new(params[:search])

   if @search.driver_id == 0
         @driver_expenses = DriverExpense.find_by_sql(['SELECT * FROM driver_expenses where 
                   driver_expenses."DATE" BETWEEN ? AND ? ORDER BY driver_expenses."DATE" DESC, driver_expenses."DRIVER_id" ASC ', 
                   event_to_date(@search.date_from), event_to_date(@search.date_to)])
    else
         @driver_expenses = DriverExpense.find_by_sql(['SELECT * FROM driver_expenses where driver_expenses."DRIVER_id" = ? AND
                   driver_expenses."DATE" BETWEEN ? AND ? ORDER BY driver_expenses."DATE" DESC, driver_expenses."DRIVER_id" ASC ', 
                  @search.driver_id, event_to_date(@search.date_from), event_to_date(@search.date_to)])
    end

    
    @drivers = Driver.all
    @trucks = Truck.all
    respond_to do |format|
        format.html
        format.csv  { send_data @driver_expenses.to_csv, filename: "driver_expenses-#{Time.now.strftime('s%S/m%M/h%H/')+Date.today.strftime('d%d/m%m/y%Y')}.csv" }   
        format.xls #{ send_data @trucks.to_csv(col_sep: "\t") }
      end
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

    if @driver_expense.images.count>0
     @driver_expense.images.attach(params[:driver_expense][:images])
    end

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

  def delete_image
    @image = ActiveStorage::Attachment.find(params[:id])
    @image.purge
    redirect_back(fallback_location: driver_expenses_path)
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
      @truck = Truck.find(@driver_expense.truck_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def driver_params
      params.require(:driver).permit(:FIRST_NAME, :SECOND_NAME)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def driver_expense_params
      params.require(:driver_expense).permit(:truck_id, :DRIVER_id, :DATE, :AMOUNT, :INFO, :DESCRIPTION, images: [])
    end
end
