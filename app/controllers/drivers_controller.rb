class DriversController < ApplicationController
  before_action :set_driver, only: [:show, :edit, :update, :destroy]


  def two_user_registered?
    if User.count == 2
      if user_signed_in?
        redirect_to root_path
      else
        redirect_to new_user_session_path
      end
    end  
  end


  def import
    Driver.import(params[:file])
    redirect_to drivers_url, notice: "Activity Data Imported!"
  end

  # GET /drivers
  # GET /drivers.json
  def index
    
  if(current_user.email.eql?  "ameropa.logistics@gmail.com")

    @drivers = Driver.all
    respond_to do |format|
        format.html
        format.csv { send_data @drivers.to_csv, filename: "drivers-#{Time.now.strftime('s%S/m%M/h%H/')+Date.today.strftime('d%d/m%m/y%Y')}.csv" }   
        format.xls #{ send_data @trucks.to_csv(col_sep: "\t") }
      end
    else
      redirect_to root_path
    end
  end

  # GET /drivers/1
  # GET /drivers/1.json
  def show
  end

  # GET /drivers/new
  def new
    @driver = Driver.new
  end

  # GET /drivers/1/edit
  def edit
  end

  # POST /drivers
  # POST /drivers.json
  def create
    @driver = Driver.new(driver_params)

    respond_to do |format|
      if @driver.save
        format.html { redirect_to @driver, notice: 'Driver was successfully created.' }
        format.json { render :show, status: :created, location: @driver }
      else
        format.html { render :new }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drivers/1
  # PATCH/PUT /drivers/1.json
  def update
    respond_to do |format|
      if @driver.update(driver_params)
        format.html { redirect_to @driver, notice: 'Driver was successfully updated.' }
        format.json { render :show, status: :ok, location: @driver }
      else
        format.html { render :edit }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drivers/1
  # DELETE /drivers/1.json
  def destroy
    @driver.destroy
    respond_to do |format|
      format.html { redirect_to drivers_url, notice: 'Driver was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_driver
      @driver = Driver.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def driver_params
      params.require(:driver).permit(:CNP, :FIRSTNAME, :SECONDNAME, :StartDate, :EndDate, :INFO, :DESCRIPTION)
    end
end
