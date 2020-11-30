class DeTollsController < ApplicationController
  before_action :set_de_toll, only: [:show, :edit, :update, :destroy]


  def import
    DeToll.import(params[:file])
    redirect_to de_tolls_url, notice: "Activity Data Imported!"
  end 


  def import_as24
    DeToll.import_as24(params[:file])
    redirect_to de_tolls_url, notice: "Activity Data Imported!"
  end 

  # GET /de_tolls
  # GET /de_tolls.json
  def index

    @search = TransactionSearch.new(params[:search], 3)

    #@de_tolls = DeToll.all.order("platenr ASC, date ASC, time ASC ")

    #@de_tolls = DeToll.all.order("platenr ASC, date ASC, time ASC ")

 if @search.truck_id == 0
 @de_tolls = DeToll.find_by_sql(["SELECT * FROM de_tolls where  
                  de_tolls.date BETWEEN ? AND ? ORDER BY 
                  de_tolls.date ASC", @search.date_from, @search.date_to ])
else

 @de_tolls = DeToll.find_by_sql(["SELECT * FROM de_tolls where de_tolls.truck_id = ? AND 
                  de_tolls.date BETWEEN ? AND ? ORDER BY 
                  de_tolls.date ASC", @search.truck_id, @search.date_from, @search.date_to ])
 end

@total_de_tolls = 0.to_d


@de_tolls.each { |a| @total_de_tolls += a.eur}


 #    @de_tolls = DeToll.find_by_sql(["SELECT * FROM de_tolls where 
  #                de_tolls.date BETWEEN ? AND ? ORDER BY 
   #               de_tolls.date ASC", @search.date_from, @search.date_to ])


      respond_to do |format|
        format.html
        format.csv  { send_data @de_tolls.to_csv, filename: "de_tolls-#{Time.now.strftime('s%S/m%M/h%H/')+Date.today.strftime('d%d/m%m/y%Y')}.csv" }   
        format.xls #{ send_data @trucks.to_csv(col_sep: "\t") }
      end

  end

  # GET /de_tolls/1
  # GET /de_tolls/1.js 
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
