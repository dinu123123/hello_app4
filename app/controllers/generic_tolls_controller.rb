class GenericTollsController < ApplicationController
  before_action :set_generic_toll, only: [:show, :edit, :update, :destroy]

  # GET /generic_tolls
  # GET /generic_tolls.json
  def index
    @generic_tolls = GenericToll.all
    @trucks = Truck.all
  end

  # GET /generic_tolls/1
  # GET /generic_tolls/1.json
  def show
    @trucks = Truck.all
  end

  # GET /generic_tolls/new
  def new
    @generic_toll = GenericToll.new
  end

  # GET /generic_tolls/1/edit
  def edit
  end

  # POST /generic_tolls
  # POST /generic_tolls.json
  def create
    @generic_toll = GenericToll.new(generic_toll_params)

    respond_to do |format|
      if @generic_toll.save
        format.html { redirect_to @generic_toll, notice: 'Generic toll was successfully created.' }
        format.json { render :show, status: :created, location: @generic_toll }
      else
        format.html { render :new }
        format.json { render json: @generic_toll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /generic_tolls/1
  # PATCH/PUT /generic_tolls/1.json
  def update
    respond_to do |format|
      if @generic_toll.update(generic_toll_params)
        format.html { redirect_to @generic_toll, notice: 'Generic toll was successfully updated.' }
        format.json { render :show, status: :ok, location: @generic_toll }
      else
        format.html { render :edit }
        format.json { render json: @generic_toll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /generic_tolls/1
  # DELETE /generic_tolls/1.json
  def destroy
    @generic_toll.destroy
    respond_to do |format|
      format.html { redirect_to generic_tolls_url, notice: 'Generic toll was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_generic_toll
      @generic_toll = GenericToll.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def generic_toll_params
      params.require(:generic_toll).permit(:StartDate, :EndDate, :Km, :EUR, :truck_id, :country)
    end
end
