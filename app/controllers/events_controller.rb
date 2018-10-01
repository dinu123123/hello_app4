class EventsController < ApplicationController
  before_action :set_driver_truck, :set_event, :set_client,
   only: [:show, :edit, :update, :destroy]

def individual_import_db (head, rank, appRecord)
  drop_until_header_line =1
  
  for i in 0..rank-1 do
     drop_until_header_line +=  1+head[i].to_i
  end
  
  my_header = CSV.readlines(@file_name.path).drop(drop_until_header_line).first
   
  CSV.foreach(@file_name.path,headers: my_header).with_index do |row,i|
       next if i < 1+drop_until_header_line
       break if i == drop_until_header_line+head[rank].to_i+1
       appRecord.create! row.to_h
  end
end

 def import
    Event.import(params[:file])
    redirect_to events_url, notice: "Activity Data Imported!"
  end

  def import_db
    
  @file_name = params[:file]

  head = CSV.readlines(@file_name.path).first.to_a


individual_import_db(head, 0, Driver)
individual_import_db(head, 1, Truck)
individual_import_db(head, 2, Client)
individual_import_db(head, 3, TruckExpense)
individual_import_db(head, 4, DriverExpense)
individual_import_db(head, 5, Event)
individual_import_db(head, 6, DeToll)
individual_import_db(head, 7, BeToll)
individual_import_db(head, 8, GenericToll)
individual_import_db(head, 9, FuelExpense)
individual_import_db(head, 10, InvoicedTrip)




#Drivers
#   my_header = CSV.readlines(@file_name.path).drop(1).first
#   CSV.foreach(@file_name.path,headers: my_header).with_index do |row,i|
#     next if i < 1+1
#     break if i == 1+head[0].to_i+1
#     Driver.create! row.to_h
#   end

#Trucks
#   my_header = CSV.readlines(@file_name.path).drop(1+1+head[0].to_i).first
#     CSV.foreach(@file_name.path,headers: my_header).with_index do |row,i|
#     next if i < 1+1+head[0].to_i+1
#     break if i == 1+head[0].to_i+1+head[1].to_i+1 
#     Truck.create! row.to_h
#   end
#Clients
#   my_header = CSV.readlines(@file_name.path).drop(1+1+head[0].to_i+1+head[1].to_i).first
#   CSV.foreach(@file_name.path,headers: my_header).with_index do |row,i|
#   next if i < 1+1+head[0].to_i+1+head[1].to_i+1
#   break if i == 1+head[0].to_i+1+head[1].to_i+1+head[2].to_i+1
#    Client.create! row.to_h
#   end

#TruckExpenses
#   my_header = CSV.readlines(@file_name.path).drop(1+1+head[0].to_i+1+head[1].to_i+1+head[2].to_i).first
#   CSV.foreach(@file_name.path,headers: my_header).with_index do |row,i|
#     next if i < 1+1+head[0].to_i+1+head[1].to_i+1+head[2].to_i+1
#     break if i == 1+head[0].to_i+1+head[1].to_i+1+head[2].to_i+1+head[3].to_i+1
#     TruckExpense.create! row.to_h
#   end


#DriverExpenses
#   my_header = CSV.readlines(@file_name.path).drop(1+1+head[0].to_i+1+head[1].to_i+1+head[2].to_i+1+head[3].to_i).first
#   CSV.foreach(@file_name.path,headers: my_header).with_index do |row,i|
#     next if i < 1+1+head[0].to_i+1+head[1].to_i+1+head[2].to_i+1+head[3].to_i+1
#     break if i == 1+head[0].to_i+1+head[1].to_i+1+head[2].to_i+1+head[3].to_i+1+head[4].to_i+1
#     DriverExpense.create! row.to_h
#   end
       
  end


  # GET /drivers
  # GET /drivers.json
  def index
    @events = Event.all
    @drivers = Driver.all
    @trucks = Truck.all
    @clients = Client.all
    respond_to do |format|
        format.html
        format.csv { send_data @events.to_csv_special, filename: "events-#{Time.now.strftime('s%S/m%M/h%H/')+Date.today.strftime('d%d/m%m/y%Y')}.csv" }   
        format.xls #{ send_data @trucks.to_csv(col_sep: "\t") }
      end
  end

 def invoice_print 

  
  asdad
    respond_to do |format|
        format.pdf { head :no_content}
      end
  end

 def db
  if !(current_user.email.eql?  "ameropa.logistics@gmail.com")
    redirect_to root_path
  else

    @drivers = Driver.all
    @trucks = Truck.all
    @clients = Client.all

    @truck_expenses = TruckExpense.all
    @driver_expenses = DriverExpense.all
    
    @driver_events = Event.all
    @de_tolls = DeToll.all
    @be_tolls = BeToll.all

    @generic_tolls = GenericToll.all
    @fuel_expenses = FuelExpense.all
    @invoiced_trips = InvoicedTrip.all

    respond_to do |format|
       format.html
        format.csv { 

          @header = @drivers.size.to_s+"," + 
                    @trucks.size.to_s+"," +  
                    @clients.size.to_s+"," + 
                    
                    @truck_expenses.size.to_s+"," + 
                    @driver_expenses.size.to_s+"," + 
                    
                    @driver_events.size.to_s+"," + 
                    @de_tolls.size.to_s+"," + 
                    @be_tolls.size.to_s+"," + 

                    @generic_tolls.size.to_s+"," + 
                    @fuel_expenses.size.to_s+"," + 
                    @invoiced_trips.size.to_s+"\n"

          send_data @header + @drivers.to_csv+
                    @trucks.to_csv+
                    @clients.to_csv+
                    
                    @truck_expenses.to_csv+
                    @driver_expenses.to_csv+
                    
                    @driver_events.to_csv+
                    @de_tolls.to_csv+
                    @be_tolls.to_csv+

                    @generic_tolls.to_csv+
                    @fuel_expenses.to_csv+
                    @invoiced_trips.to_csv,filename: "db#{Date.today.strftime('%Y%m%d')+Time.now.strftime('%H%M%S')}.csv"}
      end
    end
  end

def num_weeks(year = Date.today.year)
  Date.new(year, 12, 28).cweek # magick date!
end




def extract_explicit
 if !(current_user.email.eql?  "ameropa.logistics@gmail.com")
    redirect_to root_path
  else
@search1 = PeriodicTransactionSearch.new(params[:search1])
@nb_weeks = num_weeks


@period_start = @search1.date_from.to_date.cweek.to_i
@period_end = @search1.date_to.to_date.cweek.to_i


if @search1.time == 2
  @period_start = @search1.date_from.to_date.month.to_i
  @period_end = @search1.date_to.to_date.month.to_i
end

if  (@period_end- @period_start)<0
    @period_start = 1
end

@arrayWeeklyTruckExpense = nil

if @search1.type ==1 
    @arrayWeeklyTruckExpense = Array.new(@period_end- @period_start+3){Array.new(Truck.all.size+2,0)}
    @arrayWeeklyTruckExpense[0][0]= "".to_s
      Truck.all.each_with_index do |truck,j|
        imortant_NB_PLATE = Truck.all[j].NB_PLATE
         if imortant_NB_PLATE[0..1].to_s.eql? "PH"
          imortant_NB_PLATE= imortant_NB_PLATE[2..6]
        end
        @arrayWeeklyTruckExpense[0][j+1]=imortant_NB_PLATE
      end  

    if  @search1.time == 1
       @arrayWeeklyTruckExpense[0][0] = "Wk/Truck".to_s
       @arrayWeeklyTruckExpense[0][Truck.all.size+1] = "Total/Wk".to_s
    else
       @arrayWeeklyTruckExpense[0][0] = "Mo/Truck".to_s
       @arrayWeeklyTruckExpense[0][Truck.all.size+1] = "Total/Mo".to_s
    end

    @arrayWeeklyTruckExpense[@period_end- @period_start+2][0] = "Total/Truck".to_s
else
    @arrayWeeklyTruckExpense = Array.new(@period_end- @period_start+3){Array.new(Driver.all.size+2,0)}
    @arrayWeeklyTruckExpense[0][0]= "".to_s
    Driver.all.each_with_index do |driver,j|
      @arrayWeeklyTruckExpense[0][j+1]=driver.FIRSTNAME+" "+driver.SECONDNAME+" "+driver.CNP
    end  
    @arrayWeeklyTruckExpense[0][0] = "Wk/Driver".to_s
    @arrayWeeklyTruckExpense[0][Driver.all.size+1] = "Total/Wk".to_s
    @arrayWeeklyTruckExpense[@period_end- @period_start+2][0] = "Total/Driver".to_s
end



for week in @period_start..@period_end do
  @arrayWeeklyTruckExpense[week-@period_start+1][0] = week
end



for week in @period_start..@period_end do
  @week_total = 0


  @date_from1 = Date.commercial(@search1.date_from.to_date.strftime("%Y").to_i, week, 1)
  @date_to1 = Date.commercial(@search1.date_from.to_date.strftime("%Y").to_i, week, 7)

  if @search1.time == 2
    @date_from1 =  Date.new(@search1.date_from.to_date.strftime("%Y").to_i, week, 1)
    @date_to1 =  @date_from1.to_date.end_of_month
  end  


  if @search1.type ==1 
  

          Truck.all.each_with_index do |truck,j|
                @search1.setDriver(0)
                @search1.setTruck(truck.id)
                @events,@truck_expenses, @total_truck_expenses,@germany_tolls,@total_germany_tolls,
                @be_tolls,@total_be_tolls,@generic_tolls,@total_generic_tolls,
                @driver_expenses,@total_driver_expenses,@invoiced_trips,@total_invoiced_trips,
                @fuel_expenses, @total_fuel_expenses,
                @total_per_truck = @search1.scope1(@date_from1, @date_to1)


                @arrayWeeklyTruckExpense[(week-@period_start+1).to_i][j+1]=@total_per_truck
                @week_total += @total_per_truck            
          end
          @arrayWeeklyTruckExpense[(week-@period_start+1).to_i][Truck.all.size+1]=@week_total  
           # Truck.all.each_with_index do |truck,j|
               for j in 1..Truck.all.size+1 do
              

              @total_per_truck = 0
               for week in @period_start..@period_end do
                    @total_per_truck +=  @arrayWeeklyTruckExpense[week-@period_start+1][j]
               end


              @arrayWeeklyTruckExpense[@period_end-@period_start+2][j]=@total_per_truck 
            end
   
   elsif @search1.type ==2

            Driver.all.each_with_index do |driver,j|
                @search1.setDriver(driver.id)
                @search1.setTruck(0)
                @events,@truck_expenses, @total_truck_expenses,@germany_tolls,@total_germany_tolls,
                @be_tolls,@total_be_tolls,@generic_tolls,@total_generic_tolls,
                @driver_expenses,@total_driver_expenses,@invoiced_trips,@total_invoiced_trips,
                @fuel_expenses, @total_fuel_expenses,

                @total_per_truck = @search1.scope1(@date_from1, @date_to1)


                @arrayWeeklyTruckExpense[(week-@period_start+1).to_i][j+1]=@total_per_truck
                @week_total += @total_per_truck            
          end
          @arrayWeeklyTruckExpense[(week-@period_start+1).to_i][Driver.all.size+1]=@week_total  

         # Truck.all.each_with_index do |truck,j|
             for j in 1..Driver.all.size+1 do
            

            @total_per_truck = 0
             for week in @period_start..@period_end do
                  @total_per_truck +=  @arrayWeeklyTruckExpense[week-@period_start+1][j]
             end


            @arrayWeeklyTruckExpense[@period_end-@period_start+2][j]=@total_per_truck 
          end

       end 
    end

    @drivers = Driver.all
    @trucks = Truck.all
    @clients = Client.all

end
  end

#############################################################
def weekly
   if !(current_user.email.eql?  "ameropa.logistics@gmail.com")
    redirect_to root_path
  else
      @search1 = PeriodicTransactionSearch.new(params[:search1])
      @nb_weeks = num_weeks


      @period_start = @search1.date_from.to_date.cweek.to_i

      if  @search1.date_to.to_date.year ==  @search1.date_from.to_date.year
          @period_end = @search1.date_to.to_date.cweek.to_i
      elsif @search1.date_to.to_date.year >  @search1.date_from.to_date.year
          @period_end = @search1.date_to.to_date.cweek.to_i+52-@search1.date_from.to_date.cweek.to_i+1
      end


      if @search1.time == 2
          @period_start = @search1.date_from.to_date.month.to_i

         if  @search1.date_to.to_date.year ==  @search1.date_from.to_date.year
            @period_end = @search1.date_to.to_date.month.to_i
         elsif @search1.date_to.to_date.year >  @search1.date_from.to_date.year
            @period_end = @search1.date_to.to_date.month.to_i+12- @search1.date_from.to_date.month.to_i+1
         end
      end

      if (@period_end- @period_start)<0
        @period_start = 1
      end

      @arrayWeeklyTruckExpense = nil

      if @search1.type ==1 
            @arrayWeeklyTruckExpense = Array.new(@period_end- @period_start+3){Array.new(Client.all.size+2,0)}
            @arrayWeeklyTruckExpense[0][0]= "".to_s

            Client.all.each_with_index do |client,j|
              @arrayWeeklyTruckExpense[0][j+1]=client.Name
            end

            if @search1.time == 1
              @arrayWeeklyTruckExpense[0][0] = "Wk/Invoices".to_s
              @arrayWeeklyTruckExpense[0][Client.all.size+1] = "Total/Wk".to_s
            end

            if @search1.time == 2
              @arrayWeeklyTruckExpense[0][0] = "Mo/Invoices".to_s
              @arrayWeeklyTruckExpense[0][Client.all.size+1] = "Total/Mo".to_s
            end

            @arrayWeeklyTruckExpense[@period_end- @period_start+2][0] = "Total/Client".to_s
      else
          @arrayWeeklyTruckExpense = Array.new(@period_end- @period_start+3){Array.new(Driver.all.size+2,0)}
          @arrayWeeklyTruckExpense[0][0]= "".to_s
          Driver.all.each_with_index do |driver,j|
            @arrayWeeklyTruckExpense[0][j+1]=driver.FIRSTNAME+" "+driver.SECONDNAME+" "+driver.CNP
          end  
          @arrayWeeklyTruckExpense[0][0] = "Wk/Driver".to_s
          @arrayWeeklyTruckExpense[0][Driver.all.size+1] = "Total/Wk".to_s
          @arrayWeeklyTruckExpense[@period_end- @period_start+2][0] = "Total/Driver".to_s
      end



      for week in @period_start..@period_end do
        if week%52>0
          @arrayWeeklyTruckExpense[week-@period_start+1][0] = week%52
        else
          @arrayWeeklyTruckExpense[week-@period_start+1][0] = 52
        end
      end




         if @search1.type ==2 and @search1.time == 2
           
         elsif @search1.type ==2 and @search1.time == 1
 
##################################
##################################                          
                @arrayDriverPaymentDates = Array.new(Driver.all.size){Array.new(53)}
                 
                Driver.all.each_with_index do |driver,j|
                 
                 @localEvent = Event.find_by_sql(['SELECT * FROM events where events."DRIVER_id" = ? 
                            and events."DATE" <= ? ORDER BY events."DATE" DESC LIMIT 1', driver.id, Date.today])

                  

                   if @localEvent.size>0 and @localEvent[0].START_END == true
                   #it means the driver is in service
                   #fill in an array with payment dates
                    
                         salaryElem = Struct.new(:date, :value)
                         tmp = salaryElem.new(@localEvent[0].DATE.prev_day, 0)

                         @arrayDriverPaymentDates[j][@localEvent[0].DATE.to_date.cweek.to_i] = tmp
                         #@arrayWeeklyTruckExpense[@localEvent[0].DATE.cweek.to_i][j] = tmp

                         i = @localEvent[0].DATE.to_date.cweek.to_i+1
                         loop do

                                tmp = salaryElem.new
                                tmp.date = @arrayDriverPaymentDates[j][i-1].date.next_day.next_month.prev_day
                                #tmp.date = @arrayWeeklyTruckExpense[i-1][j].date.next_month.prev_day

                                date_prev = @arrayDriverPaymentDates[j][i-1].date.next_day
                                #date_prev = @arrayWeeklyTruckExpense[i-1][j].date    


                               @driverExpenses = DriverExpense.find_by_sql(['SELECT * FROM driver_expenses WHERE driver_expenses."DRIVER_id" = ? AND
                                          driver_expenses."DATE" BETWEEN ? AND ? ORDER BY 
                                          driver_expenses."DATE"', driver.id, date_prev, tmp.date])
                               sum = 0

                               for i in 0...@driverExpenses.count do
                                 sum += @driverExpenses[i].AMOUNT
                               end

                               tmp.value = (driver.INFO - sum).to_i   
   
                                @arrayDriverPaymentDates[j][tmp.date.to_date.cweek.to_i] = tmp

                                #store only if within the range
                                
                                if  @period_start <= tmp.date.to_date.cweek.to_i and  tmp.date.to_date.cweek.to_i <= @period_end

                                   @arrayWeeklyTruckExpense[tmp.date.to_date.cweek.to_i- @period_start+1][j+1] = tmp
                                   
                                end

                              i = tmp.date.to_date.to_date.cweek.to_i+1
                              
                            break if tmp.date >= @search1.date_to


                         end 

                   end
              
                end      


               
else 
#################################
#################################





  @totalAll = 0
  for week in @period_start..@period_end do
        @week_total = 0


        week1 = week%52
        if week1 == 0
          week1 = 52
        end 
  

        year = 0
        if week<53
           year = @search1.date_from.to_date.strftime("%Y").to_i
        else
           year =  @search1.date_from.to_date.strftime("%Y").to_i+1
        end



        @date_from1 = Date.commercial(year, week1, 1)
        @date_to1 = Date.commercial(year, week1, 7)

        if @search1.time == 2
          @date_from1 =  Date.new(year, week1, 1)
          @date_to1 =  @date_from1.to_date.end_of_month
        end  
        

        if @search1.type ==1 
              Client.all.each_with_index do |client,j|
                     @totalInvoicedTrips = 0
                     @invoicedTrips = InvoicedTrip.find_by_sql(['SELECT * FROM invoiced_trips where invoiced_trips.client_id = ? AND
                          invoiced_trips.date >= ? AND invoiced_trips.date <= ?', client.id, 
                          @date_from1-client.PaymentDelay, @date_to1-client.PaymentDelay])
       
                     if  @invoicedTrips != nil
                         1.upto( @invoicedTrips.count) do |i|
                             @totalInvoicedTrips = @totalInvoicedTrips.to_d + @invoicedTrips[i-1].total_amount.to_d
                             if @invoicedTrips[i-1].total_amount.to_d ==200
                              
                            end
                         end
                     end  
                    
                     @arrayWeeklyTruckExpense[week-@period_start+1][j+1]=@totalInvoicedTrips
                    
                     @arrayWeeklyTruckExpense[@period_end-@period_start+2][j+1] += @totalInvoicedTrips

                     @arrayWeeklyTruckExpense[week-@period_start+1][Client.all.size+1]+=@totalInvoicedTrips

                     @totalAll += @totalInvoicedTrips
              end

          @arrayWeeklyTruckExpense[@period_end-@period_start+2][Client.all.size+1] = @totalAll

   end           
end
    end



          @drivers = Driver.all
          @trucks = Truck.all
          @clients = Client.all
end

  end


  def extract_out

 if !(current_user.email.eql?  "ameropa.logistics@gmail.com")
    redirect_to root_path
  else
    @search = TransactionSearch.new(params[:search])
    @events,@truck_expenses, @total_truck_expenses,@germany_tolls,@total_germany_tolls,
    @be_tolls,@total_be_tolls,@generic_tolls,@total_generic_tolls,
    @driver_expenses,@total_driver_expenses,@invoiced_trips,@total_invoiced_trips,
    
    @fuel_expenses, @total_fuel_expenses,
    @total_debit = @search.scope
    @drivers = Driver.all
    @trucks = Truck.all
    @clients = Client.all


end
  end


  # GET /events
  # GET /events/1
  # GET /events/1.json
  def show
  end


  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create

    @event = Event.new(event_params)
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def set_driver_truck
      @event = Event.find(params[:id])
      @driver = Driver.find(@event.DRIVER_id)
      @truck = Truck.find(@event.truck_id)
    end

    def set_client
      @client = Client.find(@event.client_id)
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:DATE, :DRIVER_id, :truck_id, :client_id, :START_END)

    end
end
