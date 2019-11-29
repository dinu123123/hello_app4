class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]


  
 @@recorded_date = Date.today-1

  # GET /activities
  # GET /activities.json
  def index
  
    if @@recorded_date.to_s !=Date.today.to_s
      @@recorded_date=Date.today

      Truck.all.each do |truck|

        if truck.active == true
             Event.order('created_at DESC').all.each do |event|
               if truck.id == event.truck_id and event.START_END == true

                 @new_Activity = Activity.create(:date => Date.today, 
                                :DRIVER_id  => event.DRIVER_id,
                                :truck_id => event.truck_id,
                                :trailer_id => event.trailer_id,
                                :client_id => event.client_id
                                )

                  break


               end
               if truck.id == event.truck_id and event.START_END == false
                break
              end
               
                 

             end 
        end       
      end
    end




    @search = TransactionSearch.new(params[:search])
     

    @activities = @search.scope_activities_index

    @drivers = Driver.all
    @trucks = Truck.all
    @trailers = Trailer.all
    @clients = Client.all


  end

  # GET /activities/1
  # GET /activities/1.json
  def show
  end

  # GET /activities/new
  def new
    @activity = Activity.new
  end

  # GET /activities/1/edit
  def edit
  end

  # POST /activities
  # POST /activities.json
  def create
    @activity = Activity.new(activity_params)

    if @activity.images.count>0
     @activity.images.attach(params[:activity][:images])
    end

    respond_to do |format|
      if @activity.save
        format.html { redirect_to @activity, notice: 'Activity was successfully created.' }
        format.json { render :show, status: :created, location: @activity }
      else
        format.html { render :new }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1
  # PATCH/PUT /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @activity, notice: 'Activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete_image
    @image = ActiveStorage::Attachment.find(params[:id])
    @image.purge
    redirect_back(fallback_location: activities_path)
  end

  # DELETE /activities/1
  # DELETE /activities/1.json
  def destroy
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to activities_url, notice: 'Activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @@recorded_date = Date.today-1
      @activity = Activity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params
      params.require(:activity).permit(:date, :DRIVER_id, :truck_id, :trailer_id, :client_id, :driver_expense_id, 
        :truck_expense_id, :start_address, :dest_addresses, :volume, :tank, :comments, images: [])
    end
end
