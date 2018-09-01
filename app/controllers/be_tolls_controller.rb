class BeTollsController < ApplicationController
  before_action :set_be_toll, only: [:show, :edit, :update, :destroy]

  # GET /be_tolls
  # GET /be_tolls.json
  def index
    @be_tolls = BeToll.all

    respond_to do |format|
        format.html
        format.csv { send_data @be_tolls.to_csv, filename: "be_tolls-#{Time.now.strftime('s%S/m%M/h%H/')+Date.today.strftime('d%d/m%m/y%Y')}.csv" }
        format.xls #{ send_data @trucks.to_csv(col_sep: "\t") }
      end

 end

  def import
    BeToll.import(params[:file])
    redirect_to be_tolls_url, notice: "Activity Data Imported!"
  end 

  # GET /be_tolls/1
  # GET /be_tolls/1.json
  def show
  end

  # GET /be_tolls/new
  def new
    @be_toll = BeToll.new
  end

  # GET /be_tolls/1/edit
  def edit
  end

  # POST /be_tolls
  # POST /be_tolls.json
  def create
    @be_toll = BeToll.new(be_toll_params)

    respond_to do |format|
      if @be_toll.save
        format.html { redirect_to @be_toll, notice: 'Be toll was successfully created.' }
        format.json { render :show, status: :created, location: @be_toll }
      else
        format.html { render :new }
        format.json { render json: @be_toll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /be_tolls/1
  # PATCH/PUT /be_tolls/1.json
  def update
    respond_to do |format|
      if @be_toll.update(be_toll_params)
        format.html { redirect_to @be_toll, notice: 'Be toll was successfully updated.' }
        format.json { render :show, status: :ok, location: @be_toll }
      else
        format.html { render :edit }
        format.json { render json: @be_toll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /be_tolls/1
  # DELETE /be_tolls/1.json
  def destroy
    @be_toll.destroy
    respond_to do |format|
      format.html { redirect_to be_tolls_url, notice: 'Be toll was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_be_toll
      @be_toll = BeToll.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def be_toll_params

      
      params.require(:be_toll).permit(:record_number, 
        :reference_number, :date_of_detailed_trip_statement, 
        :identification_of_the_road_network_user, 
        :bill_cycle_start_date, :bill_cycle_end_date, 
        :obu_serial_number, :internal_obu_identifier, 
        :country_code, :licence_plate_number, 
        :euro_emission_class, :gross_combination_weight, 
        :payment_method, :date_of_processing, 
        :date_of_usage, :toll_charger, :road_type, :route, 
        :entry_time, :charged_distance, :distance_unit, 
        :charged_amount_excluding_vat, :currency, :vat_indicator)
    end
end
