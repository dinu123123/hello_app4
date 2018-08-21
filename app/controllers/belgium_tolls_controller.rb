class BelgiumTollsController < ApplicationController
  before_action :set_belgium_toll, only: [:show, :edit, :update, :destroy]

  def import
    BelgiumToll.import(params[:file])
    redirect_to belgium_tolls_url, notice: "Activity Data Imported!"
  end

  # GET /drivers
  # GET /drivers.json
  def index
    @belgium_tolls = BelgiumToll.all
    @trucks = Truck.all
    respond_to do |format|
        format.html
        format.csv { send_data @belgium_tolls.to_csv }
        format.xls #{ send_data @trucks.to_csv(col_sep: "\t") }
      end
  end

  # GET /belgium_tolls/1
  # GET /belgium_tolls/1.json
  def show
  end

  # GET /belgium_tolls/new
  def new
    @belgium_toll = BelgiumToll.new
  end

  # GET /belgium_tolls/1/edit
  def edit
  end

  # POST /belgium_tolls
  # POST /belgium_tolls.json
  def create
    @belgium_toll = BelgiumToll.new(belgium_toll_params)

    respond_to do |format|
      if @belgium_toll.save
        format.html { redirect_to @belgium_toll, notice: 'Belgium toll was successfully created.' }
        format.json { render :show, status: :created, location: @belgium_toll }
      else
        format.html { render :new }
        format.json { render json: @belgium_toll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /belgium_tolls/1
  # PATCH/PUT /belgium_tolls/1.json
  def update
    respond_to do |format|
      if @belgium_toll.update(belgium_toll_params)
        format.html { redirect_to @belgium_toll, notice: 'Belgium toll was successfully updated.' }
        format.json { render :show, status: :ok, location: @belgium_toll }
      else
        format.html { render :edit }
        format.json { render json: @belgium_toll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /belgium_tolls/1
  # DELETE /belgium_tolls/1.json
  def destroy
    @belgium_toll.destroy
    respond_to do |format|
      format.html { redirect_to belgium_tolls_url, notice: 'Belgium toll was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_belgium_toll
      @belgium_toll = BelgiumToll.find(params[:id])
      @truck = Truck.find(@belgium_toll.truck_id)

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def belgium_toll_params
      params.require(:belgium_toll).permit(:truck_id, :StartDate, :StartTime, :EndDate, :EndTime, :Km, :EUR)
    end
end
