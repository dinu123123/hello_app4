class EventsController < ApplicationController
  before_action :set_driver_truck, :set_event, :set_client,
   only: [:show, :edit, :update, :destroy]

def num_weeks(year = Date.today.year)
  Date.new(year, 12, 28).cweek # magick date!
end

def extract_explicit
@search = PeriodicTransactionSearch.new(params[:search])
@nb_weeks = num_weeks

@week_start = @search.date_from.to_date.cweek.to_i
@week_end = @search.date_to.to_date.cweek.to_i

if  (@week_end- @week_start)<0
  @week_start = 1
end

@arrayWeeklyTruckExpense = Array.new(@week_end- @week_start+3){Array.new(Truck.all.size+2,0)}

@arrayWeeklyTruckExpense[0][0]= "".to_s
  Truck.all.each_with_index do |truck,j|
    @arrayWeeklyTruckExpense[0][j+1]=Truck.all[j].NB_PLATE
  end  

@arrayWeeklyTruckExpense[0][0] = "Wk/Truck".to_s
@arrayWeeklyTruckExpense[0][Truck.all.size+1] = "Total/Wk".to_s
@arrayWeeklyTruckExpense[@week_end- @week_start+2][0] = "Total/Truck".to_s

for week in @week_start..@week_end do
  @arrayWeeklyTruckExpense[week-@week_start+1][0] = week
end

for week in @week_start..@week_end do
  @week_total = 0
  @date_from1 = Date.commercial(@search.date_from.to_date.strftime("%Y").to_i, week, 1)
  @date_to1 = Date.commercial(@search.date_from.to_date.strftime("%Y").to_i, week, 7)

          Truck.all.each_with_index do |truck,j|
                @search.setDriver(0)
                @search.setTruck(truck.id)
                @events,@truck_expenses, @total_truck_expenses,@germany_tolls,@total_germany_tolls,
                @belgium_tolls,@total_belgium_tolls,@generic_tolls,@total_generic_tolls,
                @driver_expenses,@total_driver_expeses,@invoiced_trips,@total_invoiced_trips,
                @fuel_expenses, @total_fuel_expenses,
                @total_per_truck = @search.scope1(@date_from1, @date_to1)


                @arrayWeeklyTruckExpense[(week-@week_start+1).to_i][j+1]=@total_per_truck
                @week_total += @total_per_truck            
          end
          @arrayWeeklyTruckExpense[(week-@week_start+1).to_i][Truck.all.size+1]=@week_total  

end

 # Truck.all.each_with_index do |truck,j|
     for j in 1..Truck.all.size+1 do
    

    @total_per_truck = 0
     for week in @week_start..@week_end do
          @total_per_truck +=  @arrayWeeklyTruckExpense[week-@week_start+1][j]
     end


    @arrayWeeklyTruckExpense[@week_end-@week_start+2][j]=@total_per_truck 
  end


    @drivers = Driver.all
    @trucks = Truck.all
    @clients = Client.all
  end


  def extract_out

    @search = TransactionSearch.new(params[:search])
    @events,@truck_expenses, @total_truck_expenses,@germany_tolls,@total_germany_tolls,
    @belgium_tolls,@total_belgium_tolls,@generic_tolls,@total_generic_tolls,
    @driver_expenses,@total_driver_expeses,@invoiced_trips,@total_invoiced_trips,
    
    @fuel_expenses, @total_fuel_expenses,
    @total_debit = @search.scope
    @drivers = Driver.all
    @trucks = Truck.all
    @clients = Client.all
  end


  # GET /events
  # GET /events.json
  def index
    #@search = TransactionSearch.new(params[:search])
    #@events,@truck_expenses,@germany_tolls,@belgium_tolls,@driver_expenses = @search.scope
    @drivers = Driver.all
    @trucks = Truck.all
    @events = Event.all
    @clients = Client.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end


  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def set_driver_truck
      @event = Event.find(params[:id])
      @driver = Driver.find(@event.DRIVER_id)
      @truck = Truck.find(@event.truck_id)

      
    end

    def set_client
      @client = Client.find(@event.client_id)
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:DATE, :DRIVER_id, :truck_id, :client_id, :START_END)
    end
end
