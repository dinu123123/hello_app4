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

    @activities = Activity.find(params[:activities].keys)
    @activities.each do |activity|
      if params[:invoiced_trip_id][:id].size >0  
          activity.update_attribute(:invoiced_trip_id, params[:invoiced_trip_id][:id])
      end
    end

    @activities = Activity.update(params[:activities].keys, params[:activities].values).reject { |p| p.errors.empty? }

    if @activities.empty?
      flash[:notice] = "Activities updated"
      redirect_to activities_url
    else
      render :action => "edit_individual"
    end

end

def to_datetime (date)
  if date.to_s.include? "T" and ! (date.to_s.include? "U" )
    DateTime.parse(date).to_s.to_datetime
  else
    DateTime.parse(date.to_s.to_datetime.to_s).strftime('%Y-%m-%dT%H:%M:00').to_s.to_datetime
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


    reg_trucks = Array.new
      
    Event.order('DATE DESC').all.each do |event|

      if (@trucks.find(event.truck_id).NB_PLATE.start_with?("PH") == true or 
          @trucks.find(event.truck_id).NB_PLATE.start_with?("B") == true or
          @trucks.find(event.truck_id).NB_PLATE.start_with?("CT") == true
          ) and !(reg_trucks.include? event.truck_id)
  
        if event.START_END == false 
                reg_trucks.push(event.truck_id)

        elsif event.START_END == true 
                
                array_target = Array.new
                array_missing_days = Array.new
                array_passed_days = Array.new   
                waste = Array.new
                consumption = Array.new

               reg_trucks.push(event.truck_id)
          
               @curr_activity = Activity.find_by_sql(["SELECT * FROM activities where activities.date = ? and activities.truck_id = ? order by activities.date asc ", Date.today, event.truck_id ]) 
            



                     if @curr_activity.size == 0 and event.START_END == true

                           @prev_activity = Activity.find_by_sql(["SELECT * FROM activities where activities.date = ? and 
                                      activities.truck_id = ? order by activities.date asc ", 
                                      Date.today-1, event.truck_id ]) 

                           all_trips = InvoicedTrip.find_by_sql(['SELECT * FROM invoiced_trips where  
                                       invoiced_trips."DRIVER_id" = ? and 
                                       invoiced_trips."StartDate" >= ? ORDER BY 
                                       invoiced_trips."StartDate" ASC', 
                                       event.DRIVER_id, 
                                       to_datetime(event.DATE)])


                           all_activities = Activity.find_by_sql(["SELECT * FROM activities where activities.date >= ? 
                                      and activities.truck_id = ? and activities.volume not NULL order by activities.date asc ", event.DATE, event.truck_id ]) 

                          all_activities_before = Activity.find_by_sql(["SELECT * FROM activities where activities.date < ? 
                                      and activities.truck_id = ? and activities.volume not NULL order by activities.date desc ", event.DATE, event.truck_id ]) 


                           if all_activities != nil and all_activities.size>0
                              all_activities.each_with_index {|val, index| 
                               if index == 0
                                  if all_activities_before != nil and all_activities_before.size > 0 and all_activities_before[0].odometer != nil 
                                    consumption.push(( (all_activities[index].volume)*100/ (all_activities[index].odometer-all_activities_before[0].odometer.to_s.to_i)).to_i)
                                  else
                                    consumption.push(-1)
                                  end  
                               else 
                                  consumption.push(( (all_activities[index].volume)*100/ (all_activities[index].odometer - all_activities[index-1].odometer.to_s.to_i)).to_i)
                               end
                             }
                           end


                         #  if(all_trips)
                         #  first_trip = all_trips.first 

                            if (all_trips.size>0)


                                target = -1
   
                                @pricing = Pricing.find_by_sql(["SELECT * FROM pricings where pricings.client_id = ? 
                                           and pricings.DATETIME <= ? order by pricings.DATETIME desc", event.client_id, Date.today.to_datetime ]) 

                                if @pricing[0] != nil and @pricing[0].target != nil
                                    target = @pricing.first.target
                                end


                              first_trip = all_trips.first
                              
                               km_acc = 0 
                               missing_days_acc = 0

                               all_trips.each_with_index {|val, index| 
                                  km_acc += all_trips[index].km
                                  
                                  waste.push( (all_trips[index].km_evogps-all_trips[index].km).to_i )
                                  #waste.push( ((all_trips[index].km_evogps-all_trips[index].km)/all_trips[index].km*100000).to_i)

                                  array_passed_days.push((all_trips[index].date.to_date-all_trips[index].EndDate.to_date).to_i)

                                  if index == all_trips.size-1
                                         array_passed_days.push((Date.today.to_date-all_trips[index].EndDate.to_date).to_i)
                                  end


                               if index == 0
                          
                                       nb_days = (all_trips.first.EndDate- all_trips.first.StartDate)/(60*24*60)
                                       trg =  ((first_trip.km/nb_days)/((target.to_s.to_i+1)/30))*100
                                       array_target.push(trg.to_s.to_i)
                                       array_missing_days.push(0)  
                               else



                                 #missing_days_acc +=  (all_trips[index].StartDate.to_date - all_trips[index-1].EndDate.to_date).to_i
                                
                                 #nb_days = (all_trips[index].EndDate.to_date- all_trips.first.StartDate.to_date).to_i+1-missing_days_acc

                                 missing_days_acc +=  ((all_trips[index].StartDate - all_trips[index-1].EndDate)/(60*24*60))

                                 nb_days = ((all_trips[index].EndDate- all_trips.first.StartDate)/(60*24*60)) - missing_days_acc

                                 trg =  ((km_acc/nb_days)/(target/30))*100

                                 array_target.push(trg.to_i)
                               
                                 array_missing_days.push(missing_days_acc.floor)
                                                      
                               end 

                             }
                           
                          end


                          sum_km1 = InvoicedTrip.find_by_sql(['SELECT SUM("km") AS sum1 FROM invoiced_trips where  
                                      invoiced_trips."DRIVER_id" = ? and 
                                      invoiced_trips."StartDate" >= ? ORDER BY 
                                      invoiced_trips."StartDate" DESC, 
                                      invoiced_trips.invoice_id DESC, 
                                      invoiced_trips.client_id ASC', 
                                      event.DRIVER_id, 
                                      to_datetime(event.DATE)])[0].sum1


                          days = InvoicedTrip.find_by_sql(['SELECT SUM( JULIANDAY(datetime("EndDate","localtime")||"Z") - JULIANDAY(datetime("StartDate","localtime")||"Z") ) as days FROM invoiced_trips where  
                                      invoiced_trips."DRIVER_id" = ? and 
                                      invoiced_trips."StartDate" >= ? ORDER BY 
                                      invoiced_trips."StartDate" DESC, 
                                      invoiced_trips.invoice_id DESC, 
                                      invoiced_trips.client_id ASC', 
                                      event.DRIVER_id, 
                                      to_datetime(event.DATE)])[0].days


                         target = -1

                         if sum_km1 != nil
                            @pricing = Pricing.find_by_sql(["SELECT * FROM pricings where pricings.client_id = ? 
                                       and pricings.DATETIME <= ? order by pricings.DATETIME desc", event.client_id, Date.today.to_datetime ]) 

                            if @pricing[0] != nil and @pricing[0].target != nil
                                 target = @pricing.first.target
                            end

                       


                            trips = InvoicedTrip.find_by_sql(['SELECT * FROM invoiced_trips where  
                                       invoiced_trips."DRIVER_id" = ? and 
                                       invoiced_trips."StartDate" >= ? ORDER BY 
                                       invoiced_trips."StartDate" DESC, 
                                       invoiced_trips.invoice_id DESC, 
                                       invoiced_trips.client_id ASC', 
                                       event.DRIVER_id, 
                                       to_datetime(event.DATE)])

                            end_date = trips.first.EndDate
                            start_date = trips.last.StartDate
                            nb_days = (trips.first.EndDate.to_date- trips.last.StartDate.to_date).to_i+1
                            missing_days = nb_days-days

                            sum_km = sum_km1/days

                         else
                          sum_km = 0 
                          days = 0
                         end    

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
                                        :km => (sum_km*100/(target/30)),
                                        :days_with_client => days,
                                        :client_target => target,
                                        :comments => "[08:00]\n[09:00]\n[10:00]\n[11:00]\n[12:00]\n[13:00]\n[14:00]\n[15:00]\n[16:00]\n[17:00]".to_s
                                        )

                          @new_Activity.add_target(array_target)
                          @new_Activity.add_missing_days(array_missing_days)
                          @new_Activity.add_passed_days(array_passed_days)
                          @new_Activity.add_consumption(consumption)
                          @new_Activity.add_waste(waste)
                       end
      
                     end
          end 
       


     end # for all events  
   end

     @search = TransactionSearch.new(params[:search],1)

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



  # GET /activities
  # GET /activities.json
def index_old

 @drivers = Driver.all
 @trucks = Truck.all
 @trailers = Trailer.all
 @clients = Client.all
 @dispatchers = Dispatcher.all
 @invoiced_trips = InvoicedTrip.all


 if  @@recorded_date.to_s != Date.today.to_s
      @@recorded_date=Date.today


    reg_trucks = Array.new
      
    Event.order('DATE DESC').all.each do |event|

      if (@trucks.find(event.truck_id).NB_PLATE.start_with?("PH") == true or 
          @trucks.find(event.truck_id).NB_PLATE.start_with?("B") == true or
          @trucks.find(event.truck_id).NB_PLATE.start_with?("CT") == true
          ) and !(reg_trucks.include? event.truck_id)
  
        if event.START_END == false 
                reg_trucks.push(event.truck_id)

        elsif event.START_END == true 
                
               reg_trucks.push(event.truck_id)
      

               @curr_activity = Activity.find_by_sql(["SELECT * FROM activities where activities.date = ? and activities.truck_id = ? order by activities.date asc ", 
                Date.today, event.truck_id ]) 
            

                     if @curr_activity.size == 0 and event.START_END == true


                           @prev_activity = Activity.find_by_sql(["SELECT * FROM activities where activities.date = ? and 
                                      activities.truck_id = ? order by activities.date asc ", 
                                      Date.today-1, event.truck_id ]) 

                           all_trips = InvoicedTrip.find_by_sql(['SELECT * FROM invoiced_trips where  
                                       invoiced_trips."DRIVER_id" = ? and 
                                       invoiced_trips."StartDate" >= ? ORDER BY 
                                       invoiced_trips."StartDate" ASC', 
                                       event.DRIVER_id, 
                                       to_datetime(event.DATE)])

                         #  if(all_trips)
                         #  first_trip = all_trips.first 

                                      sum_km1 = InvoicedTrip.find_by_sql(['SELECT SUM("km") AS sum1 FROM invoiced_trips where  
                                      invoiced_trips."DRIVER_id" = ? and 
                                      invoiced_trips."StartDate" >= ? ORDER BY 
                                      invoiced_trips."StartDate" DESC, 
                                      invoiced_trips.invoice_id DESC, 
                                      invoiced_trips.client_id ASC', 
                                      event.DRIVER_id, 
                                      to_datetime(event.DATE)])[0].sum1

                                      days = InvoicedTrip.find_by_sql(['SELECT SUM( JULIANDAY("EndDate")- JULIANDAY("StartDate")+1 ) as days FROM invoiced_trips where  
                                      invoiced_trips."DRIVER_id" = ? and 
                                      invoiced_trips."StartDate" >= ? ORDER BY 
                                      invoiced_trips."StartDate" DESC, 
                                      invoiced_trips.invoice_id DESC, 
                                      invoiced_trips.client_id ASC', 
                                      event.DRIVER_id, 
                                      to_datetime(event.DATE)])[0].days

                         target = -1

                         if sum_km1 != nil
                            @pricing = Pricing.find_by_sql(["SELECT * FROM pricings where pricings.client_id = ? 
                                       and pricings.DATETIME <= ? order by pricings.DATETIME desc", event.client_id, Date.today.to_datetime ]) 

                            if @pricing[0] != nil and @pricing[0].target != nil
                                 target = @pricing.first.target
                            end


                            trips = InvoicedTrip.find_by_sql(['SELECT * FROM invoiced_trips where  
                                       invoiced_trips."DRIVER_id" = ? and 
                                       invoiced_trips."StartDate" >= ? ORDER BY 
                                       invoiced_trips."StartDate" DESC, 
                                       invoiced_trips.invoice_id DESC, 
                                       invoiced_trips.client_id ASC', 
                                       event.DRIVER_id, 
                                       to_datetime(event.DATE)])

                            end_date = trips.first.EndDate
                            start_date = trips.last.StartDate
                            nb_days = (trips.first.EndDate.to_date- trips.last.StartDate.to_date).to_i+1
                            missing_days = nb_days-days

                            if nb_days == 200
                              adasda
                            end
                            sum_km = sum_km1/(days+1)

                         else
                          sum_km = 0 
                          days = 0
                         end    

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
                                        :km => (sum_km*100/(target/30)),
                                        :days_with_client => days,
                                        :client_target => target,
                                        :comments => "[08:00]\n[09:00]\n[10:00]\n[11:00]\n[12:00]\n[13:00]\n[14:00]\n[15:00]\n[16:00]\n[17:00]".to_s
                                        )
      
                     end
          end 
       end



     end # for all events  
   end

     @search = TransactionSearch.new(params[:search],1)

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

    @search = TransactionSearch.new(params,1)  
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
        :end_time, :night_break, :weekend_break, :invoiced_trip_id, :dispatcher_id, :km_evogps, :km, 
        :days_with_client, :client_target, :odometer, images: [], trip_images: [],  array_target: [], 
        array_passed_days: [], array_missing_days: [], waste: [], consumption: [])
    end

end
