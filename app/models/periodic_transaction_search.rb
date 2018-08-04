class PeriodicTransactionSearch 
  attr_reader :date_from, :date_to, :truck_id, :driver_id, :truck_events

  def initialize(params)
    params ||= {}
    @date_from = parsed_date(params[:date_from],300.days.ago.to_date.to_s)

    @date_to = parsed_date(params[:date_to], Date.today.to_s)
    

    @time = parsed_time_interval(params[:interval], 1)


    @type = parsed_trucks_drivers(params[:type], 1)




  end


def setDriver(a)
  @driver_id = a
end


def setTruck(a)
  @truck_id = a
end

def scope1(date_from1, date_to1)
# return  Event.where('date BETWEEN ? AND ?', date_from1, date_to1),
#           TruckExpense.where('date BETWEEN ? AND ?', date_from1, date_to1), 
#         DriverExpense.where('date BETWEEN ? AND ?', date_from1, date_to1)

arrayTruckExpense = Array.new
arrayGermanyToll = Array.new
arrayBelgiumToll = Array.new
arrayGenericToll = Array.new
arrayDriverExpenses = Array.new
arrayFuelExpenses = Array.new
arrayInvoicedTrips = Array.new
arrayEvents = Array.new


@totalTruckExpense = 0
@totalGermanyToll = 0
@totalBelgiumToll = 0
@totalGenericToll = 0
@totalDriverExpenses = 0
@totalInvoicedTrips = 0
@totalFuelExpenses = 0
@total_debit = 0


if @driver_id > 0
              @localEvent = Event.find_by_sql(['SELECT * FROM events where events."DRIVER_id" = ? 
              and events."DATE" BETWEEN ? AND ? ORDER BY events."DATE" ASC', @driver_id, date_from1, date_to1])

              if @localEvent.count > 0 
                  if @localEvent.count%2 == 1
                      if @localEvent[0].START_END == true
                         #append at the end the date_to1 as it comes from the form interval
                         @localEvent.push(@localEvent[@localEvent.count-1].dup)
                         @localEvent[@localEvent.count-1].id = @localEvent.count
                         @localEvent[@localEvent.count-1].DATE = date_to1
                         @localEvent[@localEvent.count-1].START_END = false
                      else
                         #append at the beginning the date_from1 as it comes from the form interval
                         @localEvent.unshift(@localEvent[0].dup)
                         @localEvent[0].id = @localEvent.count+1
                         @localEvent[0].DATE = date_from1
                         @localEvent[0].START_END = true
                      end
                  else
                      if @localEvent[0].START_END == false
                         #append at the beginning the date_from1 as it comes from the form interval
                         @localEvent.unshift(@localEvent[0].dup)
                         @localEvent[0].id = @localEvent.count+1
                         @localEvent[0].DATE = date_from1
                         @localEvent[0].START_END = true
                         #append at the end the date_to1 as it comes from the form interval
                         @localEvent.push(@localEvent[@localEvent.count-1].dup)
                         @localEvent[@localEvent.count-1].id = @localEvent.count
                         @localEvent[@localEvent.count-1].DATE = date_to1
                         @localEvent[@localEvent.count-1].START_END = false    
                       end
                  end
              truck_events = true
            else
              truck_events = false 
            end

          #puts (@localEvent.count/2).to_s+" >>>".to_s
          1.upto( @localEvent.count/2) do |i|
          #puts @localEvent[2*(i-1)].truck_id
          #puts @localEvent[2*(i-1)+1].truck_id

                #truck_id = 0 means the truck_id is irrelevant
                if (@truck_id > 0 && @truck_id == @localEvent[2*(i-1)].truck_id) || @truck_id == 0 
                    if TruckExpense.all.size
                          @truckExpense = TruckExpense.find_by_sql(["SELECT * FROM Truck_Expenses where 
                          Truck_Expenses.truck_id = ? AND Truck_Expenses.DATE BETWEEN ? AND ? ORDER BY 
                          Truck_Expenses.DATE ASC", @localEvent[2*(i-1)].truck_id, @localEvent[2*(i-1)].DATE, 
                          @localEvent[2*(i-1)+1].DATE ])
                          
                        arrayTruckExpense.concat(@truckExpense)
                    end

                    if DeToll.all.size
                        @germanyTollExpenses = DeToll.find_by_sql(["SELECT * FROM de_tolls where 
                          de_tolls.truck_id = ? AND de_tolls.date BETWEEN ? AND ? ORDER BY 
                          de_tolls.date ASC", @localEvent[2*(i-1)].truck_id, @localEvent[2*(i-1)].DATE, 
                          @localEvent[2*(i-1)+1].DATE ])

                          0.upto( @germanyTollExpenses.size-1) do |j|
                            @germanyTollExpenses[j].via =  @germanyTollExpenses[j].via[0,10]
                          end
                           arrayGermanyToll.concat(@germanyTollExpenses)
                    end

                    if BelgiumToll.all.size
                        @belgiumTollExpenses = BelgiumToll.find_by_sql(["SELECT * FROM Belgium_Tolls where 
                          Belgium_Tolls.truck_id = ? AND Belgium_Tolls.StartDate BETWEEN ? AND ? ORDER BY 
                          Belgium_Tolls.StartDate ASC", @localEvent[2*(i-1)].truck_id, @localEvent[2*(i-1)].DATE, 
                          @localEvent[2*(i-1)+1].DATE ])
                         arrayBelgiumToll.concat(@belgiumTollExpenses)
                    end

                    if FuelExpense.all.size
                        @fuelExpenses = FuelExpense.find_by_sql(["SELECT * FROM fuel_expenses where 
                          fuel_expenses.truck_id = ? AND fuel_expenses.trsdate BETWEEN ? AND ? ORDER BY 
                          fuel_expenses.trsdate ASC", @localEvent[2*(i-1)].truck_id, @localEvent[2*(i-1)].DATE, 
                          @localEvent[2*(i-1)+1].DATE ])
                        arrayFuelExpenses.concat(@fuelExpenses)
                    end

                    if GenericToll.all.size
                        @genericTollExpenses = GenericToll.find_by_sql(["SELECT * FROM Generic_Tolls where 
                            Generic_Tolls.truck_id = ? AND Generic_Tolls.StartDate BETWEEN ? AND ? ORDER BY 
                          Generic_Tolls.StartDate ASC", @localEvent[2*(i-1)].truck_id, @localEvent[2*(i-1)].DATE, 
                          @localEvent[2*(i-1)+1].DATE ])
                         arrayGenericToll.concat(@genericTollExpenses)
                    end

                    if DriverExpense.all.size
                        @driverExpenses = DriverExpense.find_by_sql(['SELECT * FROM driver_expenses where 
                          driver_expenses."DRIVER_id" = ? and driver_expenses."DATE" BETWEEN ? AND ? ORDER BY 
                          driver_expenses."DATE"', @driver_id,  @localEvent[2*(i-1)].DATE, @localEvent[2*(i-1)+1].DATE ])
                        arrayDriverExpenses.concat(@driverExpenses)
                    end
          end
      end

          if Event.all.size
            @events = Event.find_by_sql(['SELECT * FROM events where events.driver_id = ? 
              and events."DATE" BETWEEN ? AND ? ORDER BY events."DATE" ASC, events."DRIVER_id" ASC', @driver_id, date_from1, date_to1])
            arrayEvents.concat(@events) 
          end

elsif @truck_id > 0 && @driver_id == 0



        @localEvent = Event.find_by_sql(['SELECT * FROM events where events.truck_id = ? 
              and events.DATE BETWEEN ? AND ? ORDER BY events."DATE" ASC', @truck_id, date_from1, date_to1])

puts "BEFORE XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX " .to_s + date_from1.to_s + " <> ".to_s + date_to1.to_s
puts "BEFORE XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX " .to_s + @localEvent.to_s

              if @localEvent.count > 0 



                  if @localEvent.count%2 == 1



                    if @localEvent[0].START_END == true
                       #append at the end the date_to1 as it comes from the form interval
                       @localEvent.push(@localEvent[@localEvent.count-1].dup)
                       @localEvent[@localEvent.count-1].id = @localEvent.count
                       @localEvent[@localEvent.count-1].DATE = date_to1
                       @localEvent[@localEvent.count-1].START_END = false
                    else
                       #append at the beginning the date_from1 as it comes from the form interval
                       @localEvent.unshift(@localEvent[0].dup)
                       @localEvent[0].id = @localEvent.count+1
                       @localEvent[0].DATE = date_from1
                       @localEvent[0].START_END = true
                    end
                  else
                    if @localEvent[0].START_END == false
                       #append at the beginning the date_from1 as it comes from the form interval
                       @localEvent.unshift(@localEvent[0].dup)
                       @localEvent[0].id = @localEvent.count+1
                       @localEvent[0].DATE = date_from1
                       @localEvent[0].START_END = true
                       #append at the end the date_to1 as it comes from the form interval
                       @localEvent.push(@localEvent[@localEvent.count-1].dup)
                       @localEvent[@localEvent.count-1].id = @localEvent.count
                       @localEvent[@localEvent.count-1].DATE = date_to1
                       @localEvent[@localEvent.count-1].START_END = false    
                     end
                  end
                  truck_events = true
               else
                  @localEvent = Array.new(2) { Event.new }
                  @localEvent[0].START_END = true
                  @localEvent[0].DATE = date_from1
                  @localEvent[1].START_END = false
                  @localEvent[1].DATE = date_to1
                  truck_events = false 
        
               end



puts "AFTER XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX " .to_s + @localEvent.to_s


 #puts (@localEvent.count/2).to_s+" >>>".to_s
          1.upto( @localEvent.count/2) do |i|
          #puts @localEvent[2*(i-1)].truck_id
          #puts @localEvent[2*(i-1)+1].truck_id


puts "  from " .to_s + @localEvent[2*(i-1)].DATE.to_s + " to ".to_s + @localEvent[2*(i-1)+1].DATE.to_s
 
 
                #truck_id = 0 means the truck_id is irrelevant
                    if TruckExpense.all.size
                          @truckExpense = TruckExpense.find_by_sql(["SELECT * FROM Truck_Expenses where 
                          Truck_Expenses.truck_id = ? AND Truck_Expenses.DATE BETWEEN ? AND ? ORDER BY 
                          Truck_Expenses.DATE ASC", @truck_id, @localEvent[2*(i-1)].DATE, 
                          @localEvent[2*(i-1)+1].DATE ])
                          
                        arrayTruckExpense.concat(@truckExpense)
                    end

                    if DeToll.all.size
                        @germanyTollExpenses = DeToll.find_by_sql(["SELECT * FROM de_tolls where 
                          de_tolls.truck_id = ? AND de_tolls.date BETWEEN ? AND ? ORDER BY 
                          de_tolls.date ASC", @truck_id, @localEvent[2*(i-1)].DATE, 
                          @localEvent[2*(i-1)+1].DATE ])

                          0.upto( @germanyTollExpenses.size-1) do |j|
                            @germanyTollExpenses[j].via =  @germanyTollExpenses[j].via[0,10]
                          end
puts ">>>>>>>>>>>>>>  Germany Toll  " .to_s + @germanyTollExpenses.to_s

                           arrayGermanyToll.concat(@germanyTollExpenses)
                    end

                    if BelgiumToll.all.size
                        @belgiumTollExpenses = BelgiumToll.find_by_sql(["SELECT * FROM Belgium_Tolls where 
                          Belgium_Tolls.truck_id = ? AND Belgium_Tolls.StartDate BETWEEN ? AND ? ORDER BY 
                          Belgium_Tolls.StartDate ASC", @truck_id, @localEvent[2*(i-1)].DATE, 
                          @localEvent[2*(i-1)+1].DATE ])
                         arrayBelgiumToll.concat(@belgiumTollExpenses)
                    end

                    if GenericToll.all.size
                        @genericTollExpenses = GenericToll.find_by_sql(["SELECT * FROM Generic_Tolls where 
                            Generic_Tolls.truck_id = ? AND Generic_Tolls.StartDate BETWEEN ? AND ? ORDER BY 
                          Generic_Tolls.StartDate ASC", @truck_id, @localEvent[2*(i-1)].DATE, 
                          @localEvent[2*(i-1)+1].DATE ])
                         arrayGenericToll.concat(@genericTollExpenses)
                    end

                    if FuelExpense.all.size
                        @fuelExpenses = FuelExpense.find_by_sql(["SELECT * FROM fuel_expenses where 
                          fuel_expenses.truck_id = ? AND fuel_expenses.trsdate BETWEEN ? AND ? ORDER BY 
                          fuel_expenses.trsdate ASC", @truck_id, @localEvent[2*(i-1)].DATE, 
                          @localEvent[2*(i-1)+1].DATE ])
                        arrayFuelExpenses.concat(@fuelExpenses)
                    end

                    if DriverExpense.all.size
                        @driverExpenses = DriverExpense.find_by_sql(['SELECT * FROM driver_expenses where 
                          driver_expenses."DATE" BETWEEN ? AND ? ORDER BY 
                          driver_expenses."DATE"', @localEvent[2*(i-1)].DATE, @localEvent[2*(i-1)+1].DATE ])
                        arrayDriverExpenses.concat(@driverExpenses)
                    end
                
          end

            if Event.all.size
            @events = Event.find_by_sql(['SELECT * FROM events where Events.truck_id = ? 
              and events."DATE" BETWEEN ? AND ? ORDER BY events."DATE" ASC, events."DRIVER_id" ASC', 
              @truck_id, date_from1, date_to1])
            arrayEvents.concat(@events) 
            end
else

          if TruckExpense.all.size
           @truckExpense = TruckExpense.find_by_sql(['SELECT * FROM truck_expenses where 
              truck_expenses."DATE" BETWEEN ? AND ? ORDER BY 
              truck_expenses."DATE" ASC', date_from1, date_to1 ])
          

             if (@truckExpense  and @truckExpense.size >0 )         
              arrayTruckExpense.concat(@truckExpense)
             end
          end

         if DeToll.all.size
            @germanyTollExpenses = DeToll.find_by_sql(["SELECT * FROM de_tolls where 
              de_tolls.date BETWEEN ? AND ? ORDER BY 
              de_tolls.date ASC", date_from1, date_to1 ])
            
            0.upto( @germanyTollExpenses.size-1) do |j|
                @germanyTollExpenses[j].via =  @germanyTollExpenses[j].via[0,10]
            end

            if @germanyTollExpenses
               arrayGermanyToll.concat(@germanyTollExpenses)
            end
          end

          if BelgiumToll.all.size 
            @belgiumTollExpenses = BelgiumToll.find_by_sql(['SELECT * FROM belgium_tolls where 
              belgium_tolls."StartDate" BETWEEN ? AND ? ORDER BY 
              belgium_tolls."StartDate" ASC', date_from1, date_to1 ])
           
            if @belgiumTollExpenses
             arrayBelgiumToll.concat(@belgiumTollExpenses)
            end
          end

          if GenericToll.all.size
            @genericTollExpenses = GenericToll.find_by_sql(['SELECT * FROM generic_tolls where 
              generic_tolls."StartDate" BETWEEN ? AND ? ORDER BY 
              generic_tolls."StartDate" ASC', date_from1, date_to1 ])
           if  @genericTollExpenses
             arrayGenericToll.concat(@genericTollExpenses)
           end 
          end


          if DriverExpense.all.size
            @driverExpenses = DriverExpense.find_by_sql(['SELECT * FROM driver_expenses where driver_expenses."DATE" BETWEEN ? AND ?',
              date_from1, date_to1 ])
            if @driverExpenses
            arrayDriverExpenses.concat(@driverExpenses)
            end
          end

          if InvoicedTrip.all.size
            @invoicedTrips = InvoicedTrip.find_by_sql(['SELECT * FROM invoiced_trips where   
                      invoiced_trips."StartDate" >= ? AND invoiced_trips."EndDate" <= ?', date_from1, date_to1])
             if @invoicedTrips
              arrayInvoicedTrips.concat(@invoicedTrips)
             end
          end 

          if FuelExpense.all.size
              @fuelExpenses = FuelExpense.find_by_sql(["SELECT * FROM fuel_expenses where 
                fuel_expenses.trsdate BETWEEN ? AND ? ORDER BY 
                fuel_expenses.trsdate ASC", date_from1, 
                date_to1])
              arrayFuelExpenses.concat(@fuelExpenses)
          end

          if Event.all.size
          @events = Event.find_by_sql(['SELECT * FROM events where events."DATE" BETWEEN ? 
            AND ? ORDER BY events."DRIVER_id" ASC, events."DATE" ASC', date_from1, date_to1])
          if @events
          arrayEvents.concat(@events) 
          end  
          end

          if InvoicedTrip.all.size
          @invoicedTrips = InvoicedTrip.find_by_sql(['SELECT * FROM invoiced_trips where  
                      invoiced_trips."StartDate" >= ? AND invoiced_trips."EndDate" <= ?', date_from1, date_to1])
            if @invoicedTrips
            arrayInvoicedTrips.concat(@invoicedTrips)
            end
          end    
end



  if InvoicedTrip.all.size
  @invoicedTrips = InvoicedTrip.find_by_sql(['SELECT * FROM invoiced_trips where   
              invoiced_trips."StartDate" > ? AND invoiced_trips."EndDate" < ?', date_from1, date_to1])
    if @invoicedTrips
    arrayInvoicedTrips.concat(@invoicedTrips)
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
puts ">>>>>>>>>>>>>>  arrayGermanyToll[i-1].eur.to_d ".to_s + " i= ".to_s   + i.to_s + "   " + arrayGermanyToll[i-1].eur.to_d.to_s

        @totalGermanyToll = @totalGermanyToll.to_d + arrayGermanyToll[i-1].eur.to_d
    end
end    

puts ">>>>>>>>>>>>>> @totalGermanyToll".to_s +  @totalGermanyToll.to_s

@totalBelgiumToll = 0
if  arrayBelgiumToll != nil
    1.upto( arrayBelgiumToll.count) do |i|
        @totalBelgiumToll = @totalBelgiumToll.to_d + arrayBelgiumToll[i-1].EUR.to_d
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

@total_debit = @totalTruckExpense.to_d + @totalGermanyToll.to_d

# + @totalBelgiumToll.to_d +
 #              @totalGenericToll.to_d + @totalDriverExpenses.to_d + @totalFuelExpenses.to_d




puts ">>>>>>>>>>>>>>  total_debit " .to_s + @total_debit.to_s


return     arrayEvents,
           arrayTruckExpense,
           @totalTruckExpense,
           arrayGermanyToll,
           @totalGermanyToll,
           arrayBelgiumToll,
           @totalBelgiumToll,
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

  def parsed_time_interval (n1, default)
    n1.to_i
    rescue ArgumentError, TypeError
    default.to_i
  end

  def parsed_trucks_drivers (n1, default)
    n1.to_i
    rescue ArgumentError, TypeError
    default.to_i
  end

private

    def parsed_date (date_string, default)
      Date.parse(date_string)
      rescue ArgumentError, TypeError
      default
    end

end 
  
