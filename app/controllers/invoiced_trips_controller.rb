class InvoicedTripsController < ApplicationController
  before_action :set_invoiced_trip, only: [:show, :edit, :update, :destroy]

  # GET /invoiced_trips
  # GET /invoiced_trips.json
  def index
    @invoiced_trips = InvoicedTrip.all
    @trucks = Truck.all
    @clients = Client.all
    @drivers = Driver.all
  end

  # GET /invoiced_trips/1
  # GET /invoiced_trips/1.json
  def show
  end

  # GET /invoiced_trips/new
  def new
    @invoiced_trip = InvoicedTrip.new
  end

  # GET /invoiced_trips/1/edit
  def edit
  end

  # POST /invoiced_trips
  # POST /invoiced_trips.json
  def create
    @invoiced_trip = InvoicedTrip.new(invoiced_trip_params)

    respond_to do |format|
      if @invoiced_trip.save
        format.html { redirect_to @invoiced_trip, notice: 'Invoiced trip was successfully created.' }
        format.json { render :show, status: :created, location: @invoiced_trip }
      else
        format.html { render :new }
        format.json { render json: @invoiced_trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoiced_trips/1
  # PATCH/PUT /invoiced_trips/1.json
  def update
    respond_to do |format|
      if @invoiced_trip.update(invoiced_trip_params)
        format.html { redirect_to @invoiced_trip, notice: 'Invoiced trip was successfully updated.' }
        format.json { render :show, status: :ok, location: @invoiced_trip }
      else
        format.html { render :edit }
        format.json { render json: @invoiced_trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoiced_trips/1
  # DELETE /invoiced_trips/1.json
  def destroy
    @invoiced_trip.destroy
    respond_to do |format|
      format.html { redirect_to invoiced_trips_url, notice: 'Invoiced trip was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoiced_trip
      @invoiced_trip = InvoicedTrip.find(params[:id])
      @truck  = Truck.find(@invoiced_trip.truck_id)
      @driver = Driver.find(@invoiced_trip.DRIVER_id)
      @client = Client.find(@invoiced_trip.client_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoiced_trip_params
      params.require(:invoiced_trip).permit(:invoice_id, :date, :StartDate, :EndDate, :client_id, 
        :DRIVER_id, :truck_id, :germany_toll, :belgium_toll, :swiss_toll, :france_toll, 
        :italy_toll, :uk_toll, :netherlands_toll, :km, :km_evogps, :km_driver_route_note, :total_amount)
    end
end
