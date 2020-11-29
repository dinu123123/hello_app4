class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
   
  @@recorded_date = Date.today-1

def edit_individual
    @drivers = Driver.all
    @trucks = Truck.all
    @trailers = Trailer.all
    @clients = Client.all
    @dispatchers = Dispatcher.all
    @invoiced_trips = InvoicedTrip.all

    @activities = Activity.find(params[:activity_ids])
end

def update_individual

    @drivers = Driver.all
    @trucks = Truck.all
    @trailers = Trailer.all
    @clients = Client.all
    @dispatchers = Dispatcher.all
    @invoiced_trips = InvoicedTrip.all

    @activities = Activity.update(params[:activities].keys, params[:activities].values).reject { |p| p.errors.empty? }

    if @activities.empty?
      flash[:notice] = "Activities updated"
      redirect_to activities_url
    else
      render :action => "edit_individual"
    end
end

  # GET /activities
  # GET /activities.json
  def index


    @drivers = Driver.all
    @trucks = Truck.all
    @trailers = Trailer.all
    @clients = Client.all
    @dispatchers = Dispatcher.all
    @invoiced_trips = InvoicedTrip.all

    if  @@recorded_date.to_s != Date.today.to_s
      @@recorded_date=Date.today

      Truck.all.each do |truck|

        if truck.active == true  and truck.NB_PLATE.start_with?("PH") == true    
             Event.order('DATE DESC').all.each do |event|
               @curr_activity = Activity.find_by_sql(["SELECT * FROM activities where activities.date = ? and activities.truck_id = ? order by activities.date asc ", 
                Date.today, event.truck_id ]) 
            
                     if @curr_activity.size == 0 and truck.id == event.truck_id and event.START_END == true

                                      @prev_activity = Activity.find_by_sql(["SELECT * FROM activities where activities.date = ? and activities.truck_id = ? order by activities.date asc ", 
                                        Date.today-1, event.truck_id ]) 

                                      
                                      @end_ep = 0
                                      @end_dp = 0
                                      @end_op = 0



                                      if @prev_activity[0] != nil

                                         @end_ep = @prev_activity[0].end_ep

                                         @end_dp = @prev_activity[0].end_dp
                                         
                                         @end_op = @prev_activity[0].end_op

                                      end


               
                                         @new_Activity = Activity.create(:date => Date.today, 
                                                        :DRIVER_id  => event.DRIVER_id,
                                                        :truck_id => event.truck_id,
                                                        :trailer_id => event.trailer_id,
                                                        :client_id => event.client_id,
                                                        :dispatcher_id => event.dispatcher_id,
                                                        :start_ep => @end_ep,
                                                        :start_dp => @end_dp,
                                                        :start_op => @end_op,
                                                        :end_ep => @end_ep,
                                                        :end_dp => @end_dp,
                                                        :end_op => @end_op,
                                                        :comments => "[08:00]\n[09:00]\n[10:00]\n[11:00]\n[12:00]\n[13:00]\n[14:00]\n[15:00]\n[16:00]\n[17:00]\n[18:00]".to_s
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





     respond_to do |format|
        format.html
        format.xls #{ send_data @trucks.to_csv(col_sep: "\t") }
        format.pdf do
              render pdf: "activities",
              page_size: 'A4',
              template: "activities/pdf_index.html.erb",
              layout: "pdf.html",
              orientation: "Portrait",
              lowquality: true,
              zoom: 1,
              dpi: 75
        end


      end
  





  end


 def pdf_index


    @drivers = Driver.all
    @trucks = Truck.all
    @trailers = Trailer.all
    @clients = Client.all
    @dispatchers = Dispatcher.all
    @invoiced_trips = InvoicedTrip.all

   

    @search = TransactionSearch.new(params)

  
    @activities = @search.scope_activities_index




     respond_to do |format|
        format.html
        format.xls #{ send_data @trucks.to_csv(col_sep: "\t") }
        format.pdf do
              render pdf: "activities",
              page_size: 'A4',
              template: "activities/pdf_index.html.erb",
              layout: "pdf.html",
              orientation: "Portrait",
              lowquality: true,
              zoom: 1,
              dpi: 75
        end


      end
  





  end



 def CombinexPallets
    @drivers = Driver.all
    @trucks = Truck.all
    @trailers = Trailer.all
    @clients = Client.all
    @search = TransactionSearch.new(params[:search])
    @activities = @search.scope_combinex_pallets_index

  end


def email()
  @activity = Activity.find(params[:id])
  client = Client.find(@activity.client_id)
  ActivityMailer.activity_email(client.trips_email, @activity).deliver
  redirect_back fallback_location: root_path and return @activity
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


    if @activity.trip_images.count>0
     file = @activity.trip_images.attach(params[:activity][:trip_images])
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

    #@filename = ''
    #if params[:activity][:cmr] == 1.to_s
    #  @filename = 'cmr'
    #elsif params[:activity][:trips] == 1.to_s
    #  @filename = 'ẗrip'
    #elsif params[:activity][:pallet] == 1.to_s
    #  @filename = 'pallet'
    #end  

    @activity.end_ep =  params[:activity][:start_ep].to_s.to_i-params[:activity][:dest1_unloaded_ep].to_s.to_i+params[:activity][:dest1_loaded_ep].to_s.to_i-
                        params[:activity][:dest2_unloaded_ep].to_s.to_i+params[:activity][:dest2_loaded_ep].to_s.to_i


    @activity.end_dp =  params[:activity][:start_dp].to_s.to_i-params[:activity][:dest1_unloaded_dp].to_s.to_i+params[:activity][:dest1_loaded_dp].to_s.to_i-
                        params[:activity][:dest2_unloaded_dp].to_s.to_i+params[:activity][:dest2_loaded_dp].to_s.to_i

    @activity.end_op =  params[:activity][:start_op].to_s.to_i-params[:activity][:dest1_unloaded_op].to_s.to_i+params[:activity][:dest1_loaded_op].to_s.to_i-
                        params[:activity][:dest2_unloaded_op].to_s.to_i+params[:activity][:dest2_loaded_op].to_s.to_i


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


  def delete_trip_image
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


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      #@@recorded_date = Date.today-1
      @activity = Activity.find(params[:id])
    end


   
    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params
      params.require(:activity).permit(:date, :DRIVER_id, :truck_id, :trailer_id, :client_id, :driver_expense_id, 
        :truck_expense_id, :start_address, :dest_addresses, :references, :volume, :tank, :comments, :client_comment, :email_text, :pallet,
        :email_counter,:start_ep, :start_dp , :start_op, :dest1_address, :dest1_comments, 
        :dest1_unloaded_ep, :dest1_unloaded_dp, :dest1_unloaded_op, :dest1_loaded_ep, :dest1_loaded_dp,
        :dest1_loaded_op, :dest2_address, :dest2_comments, :dest2_unloaded_ep, :dest2_unloaded_dp,
        :dest2_unloaded_op, :dest2_loaded_ep, :dest2_loaded_dp, :dest2_loaded_op, :end_ep, :end_dp, 
        :end_op , :pallets_paid_in, :pallets_paid_out, :name_advisor, :km_destination, :starting_time, :driving_time_left,
        :end_time, :night_break, :weekend_break, :invoiced_trip_id, :dispatcher_id, images: [], trip_images: [])
    end

end
