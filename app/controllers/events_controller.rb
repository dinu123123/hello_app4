class EventsController < ApplicationController
  before_action :set_driver_truck, :set_event, :set_client,
   only: [:show, :edit, :update, :destroy]


  def extract_out
    @search = TransactionSearch.new(params[:search])
    @events,@truck_expenses, @total_truck_expenses,@germany_tolls,@total_germany_tolls,
    @belgium_tolls,@total_belgium_tolls,@generic_tolls,@total_generic_tolls,
    @driver_expenses,@total_driver_expeses,@invoiced_trips,@total_invoiced_trips, @total_debit = @search.scope
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

      asdas
    end

    def set_client
      @client = Client.find(@event.client_id)
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:DATE, :DRIVER_id, :truck_id, :client_id, :START_END)
    end
end
