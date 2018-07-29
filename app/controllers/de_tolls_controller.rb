class DeTollsController < ApplicationController
  before_action :set_de_toll, only: [:show, :edit, :update, :destroy]


  def import
    DeToll.import(params[:file])
    redirect_to de_tolls_url, notice: "Activity Data Imported!"
  end 


  # GET /de_tolls
  # GET /de_tolls.json
  def index
    @de_tolls = DeToll.all
  end

  # GET /de_tolls/1
  # GET /de_tolls/1.json
  def show
  end

  # GET /de_tolls/new
  def new
    @de_toll = DeToll.new
  end

  # GET /de_tolls/1/edit
  def edit
  end

  # POST /de_tolls
  # POST /de_tolls.json
  def create
    @de_toll = DeToll.new(de_toll_params)

    respond_to do |format|
      if @de_toll.save
        format.html { redirect_to @de_toll, notice: 'De toll was successfully created.' }
        format.json { render :show, status: :created, location: @de_toll }
      else
        format.html { render :new }
        format.json { render json: @de_toll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /de_tolls/1
  # PATCH/PUT /de_tolls/1.json
  def update
    respond_to do |format|
      if @de_toll.update(de_toll_params)
        format.html { redirect_to @de_toll, notice: 'De toll was successfully updated.' }
        format.json { render :show, status: :ok, location: @de_toll }
      else
        format.html { render :edit }
        format.json { render json: @de_toll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /de_tolls/1
  # DELETE /de_tolls/1.json
  def destroy
    @de_toll.destroy
    respond_to do |format|
      format.html { redirect_to de_tolls_url, notice: 'De toll was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_de_toll
      @de_toll = DeToll.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def de_toll_params
      params.require(:de_toll).permit(:platenr, :date, :time, :bookingID, :art, :road, 
        :via, :departure, :costcentre, :tariffmodel, :axelclass, :weightclass, :emissioncat, 
        :roadoperators, :ver, :km, :eur, :truck_id)
    end
end
