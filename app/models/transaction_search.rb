class TransactionSearch 
  attr_reader :date_from, :date_to, :truck_id, :driver_id, :truck_events

  def initialize(params, large =false)
    params ||= {}
    @date_from = parsed_date(params[:date_from],30.days.ago.to_datetime.strftime('%Y-%m-%dT%H:%M') )

    @date_to = parsed_date(params[:date_to],  DateTime.now.strftime('%Y-%m-%dT%H:%M') )
    
    @driver_id = parsed_driver_id(params[:driver_id], 1)
    @truck_id = parsed_truck_id(params[:truck_id], 1)



  end

def event_to_time (date)
  if date.to_s.include? "T" and ! (date.to_s.include? "U" )
    date.strftime('2000-01-01 %H:%M:00').to_time
  else
    #Time.parse(date).strftime('2000-01-01 %H:%M:00')  
    date.strftime('2000-01-01 %H:%M:00')
  
  end

end 

def event_to_date (date)
 


  if date.to_s.include? "T" and ! (date.to_s.include? "U" )
     Date.parse(date).strftime('%Y-%m-%d').to_date
  else
    #Time.parse(date).strftime('2000-01-01 %H:%M:00')  
    Date.parse(date).to_date
  end




end

 def to_time (date)
  Time.parse(date).strftime('2000-01-01 %H:%M:00')
 end

  def to_date (date)
  Date.parse(date)
 end


def scope   
# return  Event.where('date BETWEEN ? AND ?', @date_from, @date_to),
#           TruckExpense.where('date BETWEEN ? AND ?', @date_from, @date_to), 
#         DriverExpense.where('date BETWEEN ? AND ?', @date_from, @date_to)

arrayTruckExpense = Array.new
arrayGermanyToll = Array.new
arrayBeToll = Array.new
arrayGenericToll = Array.new
arrayDriverExpenses = Array.new
arrayFuelExpenses = Array.new
arrayInvoicedTrips = Array.new
arrayEvents = Array.new


if @driver_id > 0


    if Event.all.size > 0
              @localEvent = Event.find_by_sql(['SELECT * FROM events where events."DRIVER_id" = ? 
              and events."DATE" BETWEEN ? AND ? ORDER BY events."DATE" ASC', @driver_id, @date_from, @date_to])




              if @localEvent.count > 0 
                
                  if @localEvent.count%2 == 1
                    if @localEvent[0].START_END == true
                       #append at the end the @date_to as it comes from the form interval
                       @localEvent.push(@localEvent[@localEvent.count-1].dup)
                       @localEvent[@localEvent.count-1].id = @localEvent.count
                       @localEvent[@localEvent.count-1].DATE = @date_to
                       @localEvent[@localEvent.count-1].START_END = false
                       


                    else
                       #append at the beginning the @date_from as it comes from the form interval
                       @localEvent.unshift(@localEvent[0].dup)
                       @localEvent[0].id = @localEvent.count+1
                       @localEvent[0].DATE = @date_from
                       @localEvent[0].START_END = true
                    end
                  else
                    if @localEvent[0].START_END == false
                       #append at the beginning the @date_from as it comes from the form interval
                       @localEvent.unshift(@localEvent[0].dup)
                       @localEvent[0].id = @localEvent.count+1
                       @localEvent[0].DATE = @date_from
                       @localEvent[0].START_END = true
                       #append at the end the @date_to as it comes from the form interval
                       @localEvent.push(@localEvent[@localEvent.count-1].dup)
                       @localEvent[@localEvent.count-1].id = @localEvent.count
                       @localEvent[@localEvent.count-1].DATE = @date_to
                       @localEvent[@localEvent.count-1].START_END = false    
                     end
                  end
                  truck_events = true


               else
               @localEvent = Event.find_by_sql(['SELECT * FROM  events where events."DRIVER_id" = ? 
              and events."DATE" <= ? ORDER BY events."DATE" DESC', @driver_id, @date_to])
               if( @localEvent.size >0)
                if @localEvent[0].START_END == true and  @localEvent[0].DATE <=@date_from
                  @localEvent = Array.new(2) { Event.new }
                  @localEvent[0].DRIVER_id = @driver_id
                  @localEvent[0].truck_id =  @truck_id
                  @localEvent[0].START_END = true
                  @localEvent[0].DATE = @date_from

                  @localEvent[1].DRIVER_id = @driver_id
                  @localEvent[1].truck_id =  @truck_id
                  @localEvent[1].START_END = false
                  @localEvent[1].DATE = @date_to
                  truck_events = false 
                  
                elsif @localEvent[0].START_END == true and  @localEvent[0].DATE > @date_from
                
                 @localEvent = Array.new(2) { Event.new }
                  @localEvent[0].START_END = true
                  @localEvent[0].DATE = @localEvent[0].DATE
                  @localEvent[1].START_END = false
                  @localEvent[1].DATE = @date_to
                  end  
                end
                  truck_events = false 
               end

          #puts (@localEvent.count/2).to_s+" >>>".to_s
          1.upto( @localEvent.count/2) do |i|
          #puts @localEvent[2*(i-1)].truck_id
          #puts @localEvent[2*(i-1)+1].truck_id

asdasd

                #truck_id = 0 means the truck_id is irrelevant
                if (@truck_id > 0 && @truck_id == @localEvent[2*(i-1)].truck_id) || @truck_id == 0 
                    if TruckExpense.all.size
                          @truckExpense = TruckExpense.find_by_sql(['SELECT * FROM Truck_Expenses where 
                          Truck_Expenses.truck_id = ? AND Truck_Expenses."DATE" BETWEEN ? AND ? ORDER BY 
                          Truck_Expenses."DATE" ASC', @localEvent[2*(i-1)].truck_id, @localEvent[2*(i-1)].DATE, 
                          @localEvent[2*(i-1)+1].DATE ])
                          
                        arrayTruckExpense.concat(@truckExpense)
                    end



                   if DeToll.all.size
          @germanyTollExpenses = DeToll.find_by_sql(['SELECT * FROM de_tolls where  de_tolls.truck_id = ? 
          AND ( de_tolls.date > ?  OR (de_tolls.date == ? AND  de_tolls.time >= ?)) 
          AND ( de_tolls.date < ? OR (de_tolls.date == ? AND de_tolls.time <= ?)) 
          ORDER BY de_tolls.date ASC, de_tolls.time ASC',  @localEvent[2*(i-1)].truck_id,
          event_to_date(@localEvent[2*(i-1)].DATE),   event_to_date(@localEvent[2*(i-1)].DATE),   event_to_time(@localEvent[2*(i-1)].DATE),
          event_to_date(@localEvent[2*(i-1)+1].DATE), event_to_date(@localEvent[2*(i-1)+1].DATE), event_to_time(@localEvent[2*(i-1)+1].DATE)
          ])  


#if DeToll.all.size
 #                     @germanyTollExpenses = DeToll.find_by_sql(['SELECT * FROM de_tolls where  de_tolls.truck_id = ? AND
  #                      
   #                     de_tolls.date > ? 
    #                  ',  @localEvent[2*(i-1)].truck_id,
     #                 event_to_date(   @localEvent[2*(i-1)].DATE)])
                                            






                      0.upto( @germanyTollExpenses.size-1) do |j|
                          @germanyTollExpenses[j].via =  @germanyTollExpenses[j].via[0,10]
                      end
                      if @germanyTollExpenses
                         arrayGermanyToll.concat(@germanyTollExpenses)
                      end
                    end




                     if BeToll.all.size 
                        @BeTollExpenses = BeToll.find_by_sql(['SELECT * FROM be_tolls where be_tolls.truck_id = ? AND
                        (be_tolls.date_of_usage > ? OR (be_tolls.date_of_usage == ? AND be_tolls.entry_time >= ? )) 
                        AND
                        (be_tolls.date_of_usage < ? OR (be_tolls.date_of_usage == ? AND be_tolls.entry_time  <= ? )) 
                            ORDER BY 
                            be_tolls.date_of_usage ASC, be_tolls.entry_time ASC', @localEvent[2*(i-1)].truck_id,
                            event_to_date(@localEvent[2*(i-1)].DATE), event_to_date(@localEvent[2*(i-1)].DATE), 
                            event_to_time(@localEvent[2*(i-1)].DATE),
                            event_to_date(@localEvent[2*(i-1)+1].DATE),event_to_date(@localEvent[2*(i-1)+1].DATE), 
                            event_to_time(@localEvent[2*(i-1)+1].DATE)])
                        if @BeTollExpenses
                         arrayBeToll.concat(@BeTollExpenses)
                        end

                      end

                    if FuelExpense.all.size

                        @fuelExpenses = FuelExpense.find_by_sql(['SELECT * FROM fuel_expenses where 
                          fuel_expenses.truck_id = ? AND fuel_expenses.trsdate BETWEEN ? AND ? ORDER BY 
                          fuel_expenses.trsdate ASC', @localEvent[2*(i-1)].truck_id, @localEvent[2*(i-1)].DATE, 
                          @localEvent[2*(i-1)+1].DATE ])
                        arrayFuelExpenses.concat(@fuelExpenses)
                    end

                    if GenericToll.all.size
                        @genericTollExpenses = GenericToll.find_by_sql(['SELECT * FROM Generic_Tolls where 
                            Generic_Tolls.truck_id = ? AND Generic_Tolls."StartDate" BETWEEN ? AND ? ORDER BY 
                          Generic_Tolls."StartDate" ASC', @localEvent[2*(i-1)].truck_id, @localEvent[2*(i-1)].DATE, 
                          @localEvent[2*(i-1)+1].DATE ])

                         arrayGenericToll.concat(@genericTollExpenses)
                    end

                    if DriverExpense.all.size
                        @driverExpenses = DriverExpense.find_by_sql(['SELECT * FROM driver_expenses where 
                          driver_expenses."DRIVER_id" = ? and driver_expenses."DATE" BETWEEN ? AND ? ORDER BY 
                          driver_expenses."DATE"', @driver_id.to_s,  @localEvent[2*(i-1)].DATE, @localEvent[2*(i-1)+1].DATE ])
                        arrayDriverExpenses.concat(@driverExpenses)
                    end



                     if InvoicedTrip.all.size
                        @invoicedTrips = InvoicedTrip.find_by_sql(['SELECT * FROM invoiced_trips where  invoiced_trips."DRIVER_id" = ? and
                        (( DATE(invoiced_trips."StartDate") > ?) OR ( DATE(invoiced_trips."StartDate") == ? AND TIME(invoiced_trips."StartDate") >= TIME(?) )) 
                        AND
                        ((DATE(invoiced_trips."EndDate") < ?) OR ( DATE(invoiced_trips."EndDate") == ? AND TIME(invoiced_trips."EndDate") <= TIME(?) )) 
                        ORDER BY 
                        invoiced_trips."StartDate" ASC',  @driver_id , @localEvent[2*(i-1)].DATE.to_date, @localEvent[2*(i-1)].DATE.to_date,
                         @localEvent[2*(i-1)].DATE,
                        @localEvent[2*(i-1)+1].DATE.to_date, @localEvent[2*(i-1)+1].DATE.to_date, @localEvent[2*(i-1)+1].DATE
                        ])
                         if @invoicedTrips
                          arrayInvoicedTrips.concat(@invoicedTrips)
                         end
                      end 

                end


          end

        @events = Event.find_by_sql(['SELECT * FROM events where Events."DRIVER_id" = ? 
          and events."DATE" BETWEEN ? AND ? ORDER BY events."DATE" ASC, events."DRIVER_id" ASC', 
          @driver_id, @date_from, @date_to])
        if @events
            arrayEvents.concat(@events)
        end 
    end

elsif @truck_id > 0 && @driver_id == 0

  if Event != nil and Event.all.size >0
        @localEvent = Event.find_by_sql(['SELECT * FROM events where events.truck_id = ? 
              and events."DATE" BETWEEN ? AND ? ORDER BY events."DATE" ASC', @truck_id, @date_from, @date_to])


  
              if @localEvent.count > 0 
                  if @localEvent.count%2 == 1
                    if @localEvent[0].START_END == true
                       #append at the end the @date_to as it comes from the form interval
                       @localEvent.push(@localEvent[@localEvent.count-1].dup)
                       @localEvent[@localEvent.count-1].id = @localEvent.count
                       @localEvent[@localEvent.count-1].DATE = @date_to
                       @localEvent[@localEvent.count-1].START_END = false
                    else
                       #append at the beginning the @date_from as it comes from the form interval
                       @localEvent.unshift(@localEvent[0].dup)
                       @localEvent[0].id = @localEvent.count+1
                       @localEvent[0].DATE = @date_from
                       @localEvent[0].START_END = true
                    end
                  else
                    if @localEvent[0].START_END == false
                       #append at the beginning the @date_from as it comes from the form interval
                       @localEvent.unshift(@localEvent[0].dup)
                       @localEvent[0].id = @localEvent.count+1
                       @localEvent[0].DATE = @date_from
                       @localEvent[0].START_END = true
                       #append at the end the @date_to as it comes from the form interval
                       @localEvent.push(@localEvent[@localEvent.count-1].dup)
                       @localEvent[@localEvent.count-1].id = @localEvent.count
                       @localEvent[@localEvent.count-1].DATE = @date_to
                       @localEvent[@localEvent.count-1].START_END = false    
                     end
                  end
                  truck_events = true
               else
                 @localEvent = Array.new(2) { Event.new }
                  @localEvent[0].START_END = true
                  @localEvent[0].DATE = @date_from
                  @localEvent[1].START_END = false
                  @localEvent[1].DATE = @date_to
                  truck_events = false 
               end

 #puts (@localEvent.count/2).to_s+" >>>".to_s
          1.upto( @localEvent.count/2) do |i|
          #puts @localEvent[2*(i-1)].truck_id
          #puts @localEvent[2*(i-1)+1].truck_id

                #truck_id = 0 means the truck_id is irrelevant

                    if DriverExpense.all.size
                        @driverExpenses = DriverExpense.find_by_sql(['SELECT * FROM driver_expenses where 
                          driver_expenses."DATE" BETWEEN ? AND ? ORDER BY 
                          driver_expenses."DATE"', @localEvent[2*(i-1)].DATE, @localEvent[2*(i-1)+1].DATE ])
                        arrayDriverExpenses.concat(@driverExpenses)
                    end                
          end

                  


    if InvoicedTrip.all.size
            @invoicedTrips = InvoicedTrip.find_by_sql(['SELECT * FROM invoiced_trips where  invoiced_trips."truck_id" = ? and
            (( DATE(invoiced_trips."StartDate") > ?) OR ( DATE(invoiced_trips."StartDate") == ? AND TIME(invoiced_trips."StartDate") >= TIME(?) )) 
            AND
            ((DATE(invoiced_trips."EndDate") < ?) OR ( DATE(invoiced_trips."EndDate") == ? AND TIME(invoiced_trips."EndDate") <= TIME(?) )) 
            ORDER BY 
            invoiced_trips."StartDate" ASC',  @truck_id , @date_from.to_date, @date_from.to_date, @date_from,
            @date_to.to_date, @date_to.to_date, @date_to
            ])
             if @invoicedTrips
              arrayInvoicedTrips.concat(@invoicedTrips)
             end
          end 


                    if TruckExpense.all.size
                          @truckExpense = TruckExpense.find_by_sql(['SELECT * FROM Truck_Expenses where 
                          Truck_Expenses.truck_id = ? AND Truck_Expenses."DATE" BETWEEN ? AND ? ORDER BY 
                          Truck_Expenses."DATE" ASC', @truck_id, @date_from, @date_to])
                          
                        arrayTruckExpense.concat(@truckExpense)
                    end

                    if DeToll.all.size
                      
                      @germanyTollExpenses = DeToll.find_by_sql(['SELECT * FROM de_tolls where de_tolls.truck_id = ? AND
                          ((de_tolls.date > ?) OR (de_tolls.date == ? AND TIME(de_tolls.time) >= TIME(?) )) 
                          AND ((de_tolls.date < ?) OR (de_tolls.date == ? AND TIME(de_tolls.time)  <= TIME(?) )) 
                          ORDER BY de_tolls.date ASC, de_tolls.time ASC', @truck_id, @date_from.to_date, @date_from.to_date, @date_from,
                          @date_to.to_date, @date_to.to_date, @date_to ])

                      0.upto( @germanyTollExpenses.size-1) do |j|
                        @germanyTollExpenses[j].via =  @germanyTollExpenses[j].via[0,10]
                    end
                    if @germanyTollExpenses
                       arrayGermanyToll.concat(@germanyTollExpenses)
                    end
                  end




                    if BeToll.all.size 
                      @BeTollExpenses = BeToll.find_by_sql(['SELECT * FROM be_tolls where be_tolls.truck_id = ? AND 
                      ((be_tolls.date_of_usage > ?) OR (be_tolls.date_of_usage == ? AND TIME(be_tolls.entry_time) >= TIME(?) )) 
                          AND
                          ((be_tolls.date_of_usage < ?) OR (be_tolls.date_of_usage == ? AND TIME(be_tolls.entry_time)  <= TIME(?) )) 
                          ORDER BY 
                          be_tolls.date_of_usage ASC, be_tolls.entry_time ASC', @truck_id, @date_from.to_date, @date_from.to_date, @date_from,
                                                      @date_to.to_date, @date_to.to_date, @date_to ])
                      if @BeTollExpenses
                       arrayBeToll.concat(@BeTollExpenses)
                      end
                    end






                    if GenericToll.all.size
                        @genericTollExpenses = GenericToll.find_by_sql(['SELECT * FROM Generic_Tolls where 
                            Generic_Tolls.truck_id = ? AND Generic_Tolls."StartDate" BETWEEN ? AND ? ORDER BY 
                          Generic_Tolls."StartDate" ASC', @truck_id,  @date_from, @date_to])
                         arrayGenericToll.concat(@genericTollExpenses)
                    end

                    if FuelExpense.all.size
                        @fuelExpenses = FuelExpense.find_by_sql(['SELECT * FROM fuel_expenses where 
                          fuel_expenses.truck_id = ? AND fuel_expenses.trsdate BETWEEN ? AND ? ORDER BY 
                          fuel_expenses.trsdate ASC', @truck_id, @date_from, @date_to])
                        arrayFuelExpenses.concat(@fuelExpenses)
                    end

            @events = Event.find_by_sql(['SELECT * FROM events where Events.truck_id = ? 
              and events."DATE" BETWEEN ? AND ? ORDER BY events."DATE" ASC, events."DRIVER_id" ASC', 
              @truck_id, @date_from, @date_to])
            if @events
              arrayEvents.concat(@events)
            end 
   end


else

          if TruckExpense.all.size
           @truckExpense = TruckExpense.find_by_sql(['SELECT * FROM truck_expenses where 
              truck_expenses."DATE" BETWEEN ? AND ? ORDER BY 
              truck_expenses."DATE" ASC', to_date(@date_from), to_date(@date_to) ])
          

             if (@truckExpense  and @truckExpense.size >0 )         
              arrayTruckExpense.concat(@truckExpense)
             end
          end

#         if DeToll.all.size


 #         @germanyTollExpenses = DeToll.find_by_sql(['SELECT * FROM de_tolls where 
  #              ( de_tolls.date > ?  OR (de_tolls.date == ?  )) 
   #             AND ( de_tolls.date < ? OR (de_tolls.date == ?  )) 
    #            ORDER BY de_tolls.date ASC, de_tolls.time ASC', to_date(@date_from), to_date(@date_from),
     #           to_date(@date_to), to_date(@date_to) ])
          
            

#            0.upto( @germanyTollExpenses.size-1) do |j|
 #               @germanyTollExpenses[j].via =  @germanyTollExpenses[j].via[0,10]
  #          end
          
   #         if @germanyTollExpenses
    #           arrayGermanyToll.concat(@germanyTollExpenses)
     #       end
     #     end

          if BeToll.all.size 
            @BeTollExpenses = BeToll.find_by_sql(['SELECT * FROM be_tolls where 
                (be_tolls.date_of_usage > ? OR (be_tolls.date_of_usage == ? AND be_tolls.entry_time >= ? )) 
                AND
                (be_tolls.date_of_usage < ? OR (be_tolls.date_of_usage == ? AND be_tolls.entry_time  <= ? )) 
                ORDER BY 
                be_tolls.date_of_usage ASC, be_tolls.entry_time ASC', to_date(@date_from), to_date(@date_from), 
                to_time(@date_from), to_date(@date_to), to_date(@date_to), to_time(@date_to) ])
            if @BeTollExpenses
             arrayBeToll.concat(@BeTollExpenses)
            end
          end

          if GenericToll.all.size
            @genericTollExpenses = GenericToll.find_by_sql(['SELECT * FROM generic_tolls where 
              generic_tolls."StartDate" BETWEEN ? AND ? ORDER BY 
              generic_tolls."StartDate" ASC', @date_from, @date_to ])
           if  @genericTollExpenses
             arrayGenericToll.concat(@genericTollExpenses)
           end 
          end


          if DriverExpense.all.size
            @driverExpenses = DriverExpense.find_by_sql(['SELECT * FROM driver_expenses where 
              driver_expenses."DATE" BETWEEN ? AND ?',
              @date_from, @date_to ])
            if @driverExpenses
            arrayDriverExpenses.concat(@driverExpenses)
            end
          end

          if InvoicedTrip.all.size
            @invoicedTrips = InvoicedTrip.find_by_sql(['SELECT * FROM invoiced_trips where   
            (( DATE(invoiced_trips."StartDate") > ?) OR ( DATE(invoiced_trips."StartDate") == ? AND TIME(invoiced_trips."StartDate") >= TIME(?) )) 
            AND
            ((DATE(invoiced_trips."EndDate") < ?) OR ( DATE(invoiced_trips."EndDate") == ? AND TIME(invoiced_trips."EndDate") <= TIME(?) )) 
            ORDER BY 
            invoiced_trips."StartDate" ASC', @date_from.to_date, @date_from.to_date, @date_from,
            @date_to.to_date, @date_to.to_date, @date_to
            ])
             if @invoicedTrips
              arrayInvoicedTrips.concat(@invoicedTrips)
             end
          end 


          if FuelExpense.all.size
              @fuelExpenses = FuelExpense.find_by_sql(['SELECT * FROM fuel_expenses where 
                ((fuel_expenses.trsdate > ?) OR (fuel_expenses.trsdate == ? AND TIME(fuel_expenses.trstime) >= TIME(?) )) 
                AND
                ((fuel_expenses.trsdate < ?) OR (fuel_expenses.trsdate == ? AND TIME(fuel_expenses.trstime) <= TIME(?) )) 
                ORDER BY 
                fuel_expenses.trsdate ASC,  fuel_expenses.trstime ASC', @date_from.to_date, @date_from.to_date, @date_from,
                                            @date_to.to_date, @date_to.to_date, @date_to
              ])



              arrayFuelExpenses.concat(@fuelExpenses)
          end


          if Event.all.size >0
          @events = Event.find_by_sql(['SELECT * FROM events where events."DATE" BETWEEN ? 
            AND ? ORDER BY events."DRIVER_id" ASC, events."DATE" ASC', @date_from, @date_to])
          if @events
          arrayEvents.concat(@events) 
          end  
          end

  end




@totalTruckExpense = 0
if  arrayTruckExpense != nil
    1.upto( arrayTruckExpense.count) do |i|
        @totalTruckExpense = @totalTruckExpense.to_d + arrayTruckExpense[i-1].AMOUNT.to_d
    end
end    

@totalGermanyToll = 0
if  arrayGermanyToll != nil
    1.upto( arrayGermanyToll.count) do |i|
      puts  arrayGermanyToll[i-1].eur.to_s
        @totalGermanyToll = @totalGermanyToll + arrayGermanyToll[i-1].eur.to_d
    end
end    

@totalBeToll = 0
if  arrayBeToll != nil
    1.upto( arrayBeToll.count) do |i|
        @totalBeToll = @totalBeToll.to_d + arrayBeToll[i-1].charged_amount_excluding_vat.to_d
    end
end   

@totalFuelExpenses = 0
if  arrayFuelExpenses != nil
    1.upto(arrayFuelExpenses.count) do |i|
        @totalFuelExpenses = @totalFuelExpenses.to_d + arrayFuelExpenses[i-1].eurnetamount.to_d
    end
end   




@totalGenericToll = 0
if  arrayGenericToll != nil
    1.upto( arrayGenericToll.count) do |i|
        @totalGenericToll = @totalGenericToll.to_d + arrayGenericToll[i-1].EUR.to_d
    end
end   


@totalDriverExpenses = 0
if  arrayDriverExpenses != nil
    1.upto( arrayDriverExpenses.count) do |i|
        @totalDriverExpenses = @totalDriverExpenses.to_d + arrayDriverExpenses[i-1].AMOUNT.to_d
    end
end  

@totalInvoicedTrips = 0
if  arrayInvoicedTrips != nil
    1.upto( arrayInvoicedTrips.count) do |i|
        @totalInvoicedTrips = @totalInvoicedTrips.to_d + arrayInvoicedTrips[i-1].total_amount.to_d
    end
end  

@total_debit = 
@totalTruckExpense.to_d + 
@totalGermanyToll.to_d +
@totalBeToll.to_d +
@totalGenericToll.to_d + 
@totalDriverExpenses.to_d + 
@totalFuelExpenses.to_d

return     arrayEvents,
           arrayTruckExpense,
           @totalTruckExpense,
           arrayGermanyToll,
           @totalGermanyToll,
           arrayBeToll,
           @totalBeToll,
           arrayGenericToll,
           @totalGenericToll,
           arrayDriverExpenses,
           @totalDriverExpenses,
           arrayInvoicedTrips,
           @totalInvoicedTrips,
           arrayFuelExpenses,
           @totalFuelExpenses,
           @total_debit



end 

  def parsed_driver_id (n1, default)
    n1.to_i
    rescue ArgumentError, TypeError
    default.to_i
  end

  def parsed_truck_id (n1, default)
    n1.to_i
    rescue ArgumentError, TypeError
    default.to_i
  end

private
    def parsed_date (date_string, default)
      DateTime.parse(date_string).strftime('%Y-%m-%dT%H:%M')
      rescue ArgumentError, TypeError
      default
    end

end 
  
