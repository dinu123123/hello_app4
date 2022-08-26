class EventsController < ApplicationController
  before_action :set_driver_truck, :set_event, :set_client,
   only: [:show, :edit, :update, :destroy]

def individual_import_db (input_head, rank, appRecord)
   
  head = input_head.first.to_a
  drop_until_header_line =1
  
  for i in 0..rank-1 do
     drop_until_header_line +=  1+head[i].to_i
  end
  
  my_header = input_head.drop(drop_until_header_line).first
   
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

  head = CSV.readlines(@file_name.path)


individual_import_db(head, 0, Driver)
#flash[:notice] = "Drivers tbl sucessfully imported #Driver.all.size lines!"

individual_import_db(head, 1, Truck)
#flash[:success] = "Trucks tbl sucessfully imported #Truck.all.size lines!"

individual_import_db(head, 2, Client)
#flash[:success] = "Clients tbl sucessfully imported #Client.all.size lines!"

individual_import_db(head, 3, TruckExpense)
#flash[:success] = "TruckExpenses tbl sucessfully imported #TruckExpenses.all.size lines!"

individual_import_db(head, 4, DriverExpense)
#flash[:success] = "DriverExpenses tbl sucessfully imported #DriverExpense.all.size lines!"

individual_import_db(head, 5, Event)
#flash[:success] = "Events tbl sucessfully imported #Event.all.size lines!"

individual_import_db(head, 6, DeToll)
#flash[:success] = "DeToll tbl sucessfully imported #DeToll.all.size lines!"

individual_import_db(head, 7, BeToll)
#flash[:success] = "BeToll tbl sucessfully imported #BeToll.all.size lines!"

individual_import_db(head, 8, GenericToll)
#flash[:success] = "GenericTolls tbl sucessfully imported #GenericToll.all.size lines!"

individual_import_db(head, 9, FuelExpense)
#flash[:success] = "FuelExpenses tbl sucessfully imported #FuelExpense.all.size lines!"

individual_import_db(head, 10, Invoice)
#flash[:success] = "Invoices tbl sucessfully imported #Invoice.all.size lines!"

individual_import_db(head, 11, InvoicedTrip)
#flash[:success] = "InvoicedTrip tbl sucessfully imported #InvoicedTrip.all.size lines!"

individual_import_db(head, 12, Trailer)

individual_import_db(head, 13, Pricing)

@total_size = Driver.all.size+Truck.all.size+Client.all.size+TruckExpense.all.size+DriverExpense.all.size+
             Event.all.size+DeToll.all.size+BeToll.all.size+GenericToll.all.size+FuelExpense.all.size+
              Invoice.all.size+InvoicedTrip.all.size+Trailer.all.size+Pricing.all.size
redirect_to events_url, notice: "DB sucessfully imported  lines!"

  end


  # GET /drivers
  # GET /drivers.json
  def index

    @search = TransactionSearch.new(params[:search])
    @events = @search.scope_events_index



    @drivers = Driver.all
    @trucks = Truck.all
    @trailers = Trailer.all
    @clients = Client.all
    @dispatchers = Dispatcher.all
    respond_to do |format|
        format.html
        format.csv { send_data Event.all.to_csv_special, filename: "events-#{Time.now.strftime('s%S/m%M/h%H/')+Date.today.strftime('d%d/m%m/y%Y')}.csv" }   
        format.xls #{ send_data @trucks.to_csv(col_sep: "\t") }
      end
  end

 def invoice_print 
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
    @trailers = Trailer.all
    
    @clients = Client.all

    @truck_expenses = TruckExpense.all
    @driver_expenses = DriverExpense.all
    
    @driver_events = Event.all
    @de_tolls = DeToll.all
    @be_tolls = BeToll.all

    @generic_tolls = GenericToll.all
    @fuel_expenses = FuelExpense.all
    @invoices = Invoice.all
    @invoiced_trips = InvoicedTrip.all
    @pricings = Pricing.all

    @activities = Activity.all
    @periodic_categories = PeriodicsCategory.all
    @periodics = Periodic.all   



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
                    @invoices.size.to_s+"," +
                    @invoiced_trips.size.to_s+","+
                    @trailers.size.to_s+","+
                    @pricings.size.to_s+","
                    @activities.size.to_s+","+
                    @periodic_categories.size.to_s+","+
                    @periodics.size.to_s+"\n"
                     

                    

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
                    @invoices.to_csv+
                    @invoiced_trips.to_csv+
                    @trailers.to_csv+
                    @pricings.to_csv+
                    @activities.to_csv+
                    @periodic_categories.to_csv+
                    @periodics.to_csv,filename: "db#{Date.today.strftime('%Y%m%d')+Time.now.strftime('%H%M%S')}.csv"}
      end
    end
  end

def num_weeks(year = Date.today.year)
  Date.new(year, 12, 28).cweek # magick date!
end

#def oil
#render "events/oil"
#render file: "app/views/events/oil.erb"
#redirect_back fallback_location: root_path
#the following works
#redirect_to(de_toll_file_import_path)
#sleep 5
 #redirect_to :back
#end

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

    @arrayWeeklyTruckExpense = Array.new(@period_end-@period_start+3){Array.new(Truck.all.size+2,0)}
    @arrayWeeklyTruckExpense[0][0]= "".to_s
      Truck.all.each_with_index do |truck,j|
        imortant_NB_PLATE = Truck.all[j].NB_PLATE
         if imortant_NB_PLATE[0..1].to_s.eql? "PH" or imortant_NB_PLATE[0..1].to_s.eql? "CT" or imortant_NB_PLATE[0..1].to_s.eql? "B"
          imortant_NB_PLATE= imortant_NB_PLATE[2..6]
        end
        @arrayWeeklyTruckExpense[0][j+1]=imortant_NB_PLATE
      end  

    if  @search1.time == 1
       @arrayWeeklyTruckExpense[0][0] = "Week".to_s
       @arrayWeeklyTruckExpense[0][Truck.all.size+1] = "Total".to_s
    else
       @arrayWeeklyTruckExpense[0][0] = "Month".to_s
       @arrayWeeklyTruckExpense[0][Truck.all.size+1] = "Total".to_s
    end
    @arrayWeeklyTruckExpense[@period_end- @period_start+2][0] = "Total".to_s

else

    @arrayWeeklyTruckExpense = Array.new(@period_end- @period_start+3){Array.new(Driver.all.size+2,0)}
    @arrayWeeklyTruckExpense[0][0]= "".to_s
    Driver.all.each_with_index do |driver,j|
      @arrayWeeklyTruckExpense[0][j+1]=driver.FIRSTNAME+" "+driver.SECONDNAME+" "+driver.CNP
    end  


    if  @search1.time == 1
       @arrayWeeklyTruckExpense[0][0] = "Week".to_s
    else
       @arrayWeeklyTruckExpense[0][0] = "Month".to_s
    end

    @arrayWeeklyTruckExpense[0][Driver.all.size+1] = "Total".to_s
    @arrayWeeklyTruckExpense[@period_end- @period_start+2][0] = "Total".to_s

end



for week in @period_start..@period_end do
  @arrayWeeklyTruckExpense[week-@period_start+1][0] = week
end



for week in @period_start..@period_end do
  @week_total = 0


  @date_from1 = Date.commercial(@search1.date_from.to_date.strftime("%Y").to_i, week, 1)
  @date_to1 = Date.commercial(@search1.date_to.to_date.strftime("%Y").to_i, week, 7)



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
   if false #!(current_user.email.eql?  "ameropa.logistics@gmail.com")
    # redirect_to root_path
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


      

      
      if @search1.type == 1 or @search1.type == 3 




            @arrayWeeklyTruckExpense = Array.new(@period_end- @period_start+3){Array.new(Client.all.size+2,0)}
            #up to max 30 invoices per client
            @pInvoices = Array.new(@period_end- @period_start+3){Array.new(Client.all.size+2,0) {Array.new(30,0)}}
                        
            @arrayWeeklyTruckExpense[0][0]= "".to_s

            Client.all.each_with_index do |client,j|
              @arrayWeeklyTruckExpense[0][j+1]=client.Name
            end

            if @search1.time == 1
              @arrayWeeklyTruckExpense[0][0] = "Week".to_s
              @arrayWeeklyTruckExpense[0][Client.all.size+1] = "Total".to_s
            end

            if @search1.time == 2
              @arrayWeeklyTruckExpense[0][0] = "Month".to_s
              @arrayWeeklyTruckExpense[0][Client.all.size+1] = "Total".to_s
            end

            @arrayWeeklyTruckExpense[@period_end- @period_start+2][0] = "Total".to_s
      else
      
@Drv = Driver.find_by_sql(['SELECT * FROM drivers where drivers."active" = ? ', true])

          @arrayWeeklyTruckExpense = Array.new(@period_end- @period_start+3){Array.new(@Drv.size+2,0)}
          

          @arrayWeeklyTruckExpense[0][0]= "".to_s
          @Drv.each_with_index do |driver,j|
            if driver.active 
              @arrayWeeklyTruckExpense[0][j+1]=1.to_s+driver.FIRSTNAME+" "+driver.SECONDNAME+" "+driver.CNP
            else
              @arrayWeeklyTruckExpense[0][j+1]=0.to_s+driver.FIRSTNAME+" "+driver.SECONDNAME+" "+driver.CNP
            end
              
          end  
          
          @arrayWeeklyTruckExpense[0][0] = "Week".to_s

          @arrayWeeklyTruckExpense[0][@Drv.size+1] = "Total".to_s
          @arrayWeeklyTruckExpense[@period_end- @period_start+2][0] = "Total".to_s
      end

      for week in @period_start..@period_end do
          @arrayWeeklyTruckExpense[week-@period_start+1][0] = 
           (Date.commercial(@search1.date_from.to_date.year, @search1.date_from.to_date.strftime("%W").to_i+1, 1) +(week-1)*7).cweek
      end

         if @search1.type ==2 and @search1.time == 2
           #for the time being not worth implemented
         

         elsif (@search1.type == 4  or @search1.type == 0 )  
                



                @Drv.each_with_index do |driver,j|

                 
                 @localEvent = Event.find_by_sql(['SELECT * FROM events where events."DRIVER_id" = ? and  events."client_id" = ?
                            and events."DATE" >= ? and events."DATE" <= ? ORDER BY events."DATE" ASC', driver.id, @search1.client_id, Date.today-Date.today.yday()+1, Date.today])


                   if @localEvent.size>0 
                   #it means the driver is in service
                   #fill in an array with payment dates
                    
                        
                           @localEvent.each_with_index do |event,i|
                             
                               @tmpEvent = Struct.new(:date, :type)
                               @tmp = @tmpEvent.new(event.DATE, event.START_END)
                              

                               @arrayWeeklyTruckExpense[event.DATE.strftime("%U").to_i+1][j+1] = @tmp 


                               if i == @localEvent.size-1 and event.expected_date and (@arrayWeeklyTruckExpense.length > (1+event.expected_date.strftime("%U").to_i+1))
                                 @tmpEvent = Struct.new(:date, :type)
                                 @tmp = @tmpEvent.new(event.expected_date, not(event.START_END)) 
                                 @arrayWeeklyTruckExpense[event.expected_date.strftime("%U").to_i+1][j+1] = @tmp 
                                
                               end 

                           end









                  end
                   end

 

  @arrayWeeklyTruckExpense.transpose.each_with_index { |row,i| 

@start = false



if  i == 0 

next
end 

@htotal = 0

row.each_with_index { |column,j| 
 


if   j ==0  

next

end 


  if column.is_a?(Struct) and column.type == true
      @start = true
       next
  end
   
  if  column.is_a?(Struct) and column.type == false
     @start = false
      next  
  end 



  if @start == true   
      @arrayWeeklyTruckExpense[j][i] = 1
      @htotal =  @htotal + 1
  else
      @arrayWeeklyTruckExpense[j][i] = 0
  end


if j == row.size-1 
  
      @arrayWeeklyTruckExpense[j][i] = @htotal


end

  }



}


  @arrayWeeklyTruckExpense.each_with_index { |row,i| 

start = false




if  i == 0 

next
end 

@htotal = 0

row.each_with_index { |column,j| 
 


if   j ==0  

next

end 



 if column.is_a?(Struct) 

      @htotal =  @htotal + 1
    else
    @htotal =  @htotal + column
   end   
  

if j == row.size-1 
  
      @arrayWeeklyTruckExpense[i][j] = @htotal


end

  }


}

 @arrayWeeklyTruckExpense =   @arrayWeeklyTruckExpense.transpose.reject { |column|   column[column.size-1] == 0 }
@arrayWeeklyTruckExpense =   @arrayWeeklyTruckExpense.transpose






         elsif @search1.type ==2  and @search1.time == 1
 
##################################
##################################                  


                @Drv = Driver.find_by_sql(['SELECT * FROM drivers where drivers."active" = ? ', true])

                @arrayDriverPaymentDates = Array.new(@Drv.size){Array.new(53)}



                @Drv.each_with_index do |driver,j|
                 
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

                               if driver.INFO == nil
                                 tmp.value = (2200 - sum).to_i   
                               else
                                 tmp.value = (driver.INFO - sum).to_i   
                               end

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





 @arrayWeeklyTruckExpense =   @arrayWeeklyTruckExpense.transpose()

#asdasd


#@arrayWeeklyTruckExpense = @arrayWeeklyTruckExpense[1..@arrayWeeklyTruckExpense.size-1]

 @arrayWeeklyTruckExpense =   @arrayWeeklyTruckExpense.reject { |row| row[0][0].to_s != "W" and row[0][0].to_s !=  'M' and row[0][0].to_s !=  'T' and row[0].to_i ==0 }
@arrayWeeklyTruckExpense =   @arrayWeeklyTruckExpense.each { |row| 
  if(row[0][0].to_s == '1') 
    row[0][0]="" end 
  }


 @arrayWeeklyTruckExpense = @arrayWeeklyTruckExpense.transpose()


               
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



        #@date_from1 = Date.commercial(year, week1, 1)
        #@date_to1 = Date.commercial(year, week1, 7)

##Last repair

        @date_start =  Date.commercial(@search1.date_from.to_date.year, @search1.date_from.to_date.strftime("%W").to_i+1, 1)


        @date_from1 =  @date_start+(week-1)*7
        @date_to1 =  @date_from1+6





        if @search1.time == 2
          @date_from1 =  Date.new(year, week1, 1)
          @date_to1 =  @date_from1.to_date.end_of_month
        end  
        

        if @search1.type != 2 

              Client.all.each_with_index do |client,j|
                     @totalInvoicedTrips = 0
      
                   #  @invoicedTrips = InvoicedTrip.find_by_sql(['SELECT * FROM invoiced_trips where invoiced_trips.client_id = ? AND
                   #       invoiced_trips.date >= ? AND invoiced_trips.date <= ?', client.id, 
                   #       @date_from1-client.PaymentDelay, @date_to1-client.PaymentDelay])
      
                   #  if  @invoicedTrips != nil
                   #      1.upto( @invoicedTrips.count) do |i|
                   #          @totalInvoicedTrips = @totalInvoicedTrips.to_d + @invoicedTrips[i-1].total_amount.to_d 
                   #      end
                   #  end  


                   if @search1.type == 1   

#                     if client.PaymentDelay != nil 
#                       @invoices = Invoice.find_by_sql(['SELECT * FROM invoices where ddate = ? AND invoices.client_id = ? AND
#                          invoices.date >= ? AND invoices.date <= ?','2000-01-01', client.id, 
#                          @date_from1-client.PaymentDelay, @date_to1-client.PaymentDelay])
#                      else
#                       @invoices = Invoice.find_by_sql(['SELECT * FROM invoices where invoices.client_id = ? AND
#                          invoices.ddate >= ? AND invoices.ddate <= ?', client.id, 
#                          @date_from1, @date_to1])
#                      end

                        if client.PaymentDelay != nil 

                        @invoices = Invoice.find_by_sql(['SELECT * FROM invoices where ddate = ? AND invoices.client_id = ? AND
                          invoices.date >= ? AND invoices.date <= ?','2000-01-01', client.id,
                          @date_from1-client.PaymentDelay, @date_to1-client.PaymentDelay]) + 
                        Invoice.find_by_sql(['SELECT * FROM invoices where invoices.client_id = ? AND
                          invoices.ddate >= ? AND invoices.ddate <= ?', client.id,
                          @date_from1, @date_to1])
                        else
                          @invoices = Invoice.find_by_sql(['SELECT * FROM invoices where invoices.client_id = ? AND
                          invoices.ddate >= ? AND invoices.ddate <= ?', client.id,
                          @date_from1, @date_to1])
                       end

                   elsif @search1.type == 3 
                       @invoices = Invoice.find_by_sql(['SELECT * FROM invoices where invoices.client_id = ? AND
                          invoices.date >= ? AND invoices.date <= ?', client.id, 
                          @date_from1, @date_to1])
                   end


                     if  @invoices != nil
                         1.upto( @invoices.count) do |k|
                             @totalInvoicedTrips = @totalInvoicedTrips.to_d + @invoices[k-1].total_amount.to_d 
                             @pInvoices[week-@period_start+1][j+1][k-1]=@invoices[k-1]
                      
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


  @arrayWeeklyTruckExpense = @arrayWeeklyTruckExpense.transpose() 
  
  if @pInvoices != nil
    @pInvoices = @pInvoices.transpose()
  end


  @arrayWeeklyTruckExpense.each_with_index {|column, i|   
    if (column.first.to_s[0] != "W" and    column.last.to_i == 0)
       if @pInvoices != nil
         @pInvoices.delete_at(i)
       end
       @arrayWeeklyTruckExpense.delete column
    end
  }

   if @pInvoices != nil
     @pInvoices =  @pInvoices.transpose()
   end 
   @arrayWeeklyTruckExpense = @arrayWeeklyTruckExpense.transpose()
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
    @total_debit,
    @total_km_evogps,
    @total_km_invoiced,
    @total_toll_invoiced = @search.scope

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

    if @event.images.count>0
     @event.images.attach(params[:event][:images])
    end

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

  def delete_image
    @image = ActiveStorage::Attachment.find(params[:id])
    @image.purge
    redirect_back(fallback_location: events_path)
  end

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

      if @event.trailer_id
        @trailer = Trailer.find(@event.trailer_id)
      else
        @trailer = nil
      end

    end

    def set_client
      @client = Client.find(@event.client_id)
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      #params.require(:event).permit(:DATE, :DRIVER_id, :truck_id, :client_id, :START_END, :picture)
      params.require(:event).permit(:DATE, :DRIVER_id, :truck_id, :trailer_id, :client_id, :dispatcher_id, :START_END, :volume, :km, :expected_date, images: [] )
    end



end
