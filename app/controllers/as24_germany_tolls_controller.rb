class As24GermanyTollsController < ApplicationController
  before_action :set_as24_germany_toll, only: [:show, :edit, :update, :destroy]

  # GET /as24_germany_tolls
  # GET /as24_germany_tolls.json
  def index
    @as24_germany_tolls = As24GermanyToll.all
  end

  # GET /as24_germany_tolls/1
  # GET /as24_germany_tolls/1.json
  def show
  end

  # GET /as24_germany_tolls/new
  def new
    @as24_germany_toll = As24GermanyToll.new
  end

  # GET /as24_germany_tolls/1/edit
  def edit
  end

  # POST /as24_germany_tolls
  # POST /as24_germany_tolls.json
  def create
    @as24_germany_toll = As24GermanyToll.new(as24_germany_toll_params)

    respond_to do |format|
      if @as24_germany_toll.save
        format.html { redirect_to @as24_germany_toll, notice: 'As24 germany toll was successfully created.' }
        format.json { render :show, status: :created, location: @as24_germany_toll }
      else
        format.html { render :new }
        format.json { render json: @as24_germany_toll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /as24_germany_tolls/1
  # PATCH/PUT /as24_germany_tolls/1.json
  def update
    respond_to do |format|
      if @as24_germany_toll.update(as24_germany_toll_params)
        format.html { redirect_to @as24_germany_toll, notice: 'As24 germany toll was successfully updated.' }
        format.json { render :show, status: :ok, location: @as24_germany_toll }
      else
        format.html { render :edit }
        format.json { render json: @as24_germany_toll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /as24_germany_tolls/1
  # DELETE /as24_germany_tolls/1.json
  def destroy
    @as24_germany_toll.destroy
    respond_to do |format|
      format.html { redirect_to as24_germany_tolls_url, notice: 'As24 germany toll was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_as24_germany_toll
      @as24_germany_toll = As24GermanyToll.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def as24_germany_toll_params
      params.require(:as24_germany_toll).permit(:contract, :vehicle_card, :driver_card, :product_code, :product, :volume, :date, :time, :country, :site_nbr, :station, :invoice_date, :invoice_nbr, :vat_rate, :transation_currency, :transaction_excl_vat, :transaction_vat, :transaction_incl_vat, :payment_currency, :payment_excl_vat, :miles, :immatriculation, :document_type)
    end
end
