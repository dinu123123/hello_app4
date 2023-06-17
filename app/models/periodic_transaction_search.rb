class Element
   attr_reader :name, :id

   def initialize (a,b)
    @name = a
    @id = b
  end
end

class PeriodicTransactionSearch 
  attr_reader :date_from, :date_to, :time, :type, :type2, :truck_id, :driver_id, 
  :truck_events, :running, :running_truck_id, :arrayH, :arrayT, :arrayC, :arrayD, :active, :client_id

  def initialize(params)
    params ||= {}
    @date_from = parsed_date(params[:date_from], (DateTime.now.beginning_of_year()).strftime('%Y-%m-%d'))
    @date_to = parsed_date(params[:date_to],  (Date.today+2.month).strftime('%Y-%m-%d'))
    @time = parsed_time_interval(params[:interval], 1)

    @time = parsed_period(params[:time], 1)
    @type = parsed_trucks_drivers(params[:type], 1)
    
    @client_id = parsed_clients(params[:client_id], 1)


    @active = parsed_active(params[:active], 1)

    a =Element.new("Drivers",2)
    b =Element.new("Trucks",1)    
    @arrayH = []
    @arrayH.push(a)
    @arrayH.push(b)
        
    a1 =Element.new("Weeks",1)
    b1 =Element.new("Months",2)    
    @arrayT = []
    @arrayT.push(a1)
    @arrayT.push(b1)

    a2 =Element.new("InvoicesPaid",1)
    b2 =Element.new("Salaries",2)    
    a3 =Element.new("InvoicesIssued",3)
    
    a4 =Element.new("DriversSchedule",4)
    a5 =Element.new("Dispatchers",5)
    a6 =Element.new("Drivers",5)
    a7 =Element.new("Trucks",5)
        
    @arrayC = []
    @arrayC.push(a2)
    @arrayC.push(b2)
    @arrayC.push(a3)
    @arrayC.push(a4)
    @arrayC.push(a5)
    @arrayC.push(a6)
    @arrayC.push(a7)
 
    @arrayDisp = []
    @arrayDisp.push(a4)
    @arrayDisp.push(a5)
 
    a3 =Element.new("Active",1)
    b3 =Element.new("Inactive",2)    
    c3 =Element.new("All",3)
    @arrayD = []
    @arrayD.push(a3)
    @arrayD.push(b3)
    @arrayD.push(c3)

  end

def to_datetime (date)
  if date.to_s.include? "T" and ! (date.to_s.include? "U" )
    DateTime.parse(date).to_datetime
  else
    DateTime.parse(date.to_datetime.to_s).strftime('%Y-%m-%dT%24:%00:00').to_datetime
  end
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
arrayBeToll = Array.new
arrayGenericToll = Array.new
arrayDriverExpenses = Array.new
arrayFuelExpenses = Array.new
arrayInvoicedTrips = Array.new
arrayEvents = Array.new


@totalTruckExpense = 0
@totalGermanyToll = 0
@totalBeToll = 0
@totalGenericToll = 0
@totalDriverExpenses = 0
@totalInvoicedTrips = 0
@totalFuelExpenses = 0
@total_debit = 0

@localEvent = nil


if @type == 1


         if TruckExpense.all.size
                 @truckExpense = TruckExpense.find_by_sql(['SELECT * FROM truck_expenses where truck_expenses.truck_id = ? and
                    truck_expenses."DATE" BETWEEN ? AND ? ORDER BY 
                    truck_expenses."DATE" ASC', @truck_id, date_from1, date_to1 ])
                

                  if (@truckExpense  and @truckExpense.size >0 )         
                    arrayTruckExpense.concat(@truckExpense)
                 end
         end





         if DeToll.all.size
                @germanyTollExpenses = DeToll.find_by_sql(["SELECT * FROM de_tolls where de_tolls.truck_id = ? AND 
                  de_tolls.date BETWEEN ? AND ? ORDER BY 
                  de_tolls.date ASC", @truck_id, date_from1, date_to1 ])
                
                0.upto( @germanyTollExpenses.size-1) do |j|
                    @germanyTollExpenses[j].via =  @germanyTollExpenses[j].via[0,10]
                end



                if @germanyTollExpenses
                   arrayGermanyToll.concat(@germanyTollExpenses)
                end
          end

          if BeToll.all.size 
                @belgiumTollExpenses = BeToll.find_by_sql(['SELECT * FROM be_tolls where Be_Tolls.truck_id = ? AND
                  be_tolls.date_of_usage BETWEEN ? AND ? ORDER BY 
                  be_tolls.date_of_usage ASC', @truck_id, date_from1, date_to1 ])
               
                if @belgiumTollExpenses
                 arrayBeToll.concat(@belgiumTollExpenses)
                end
          end

          if GenericToll.all.size
                @genericTollExpenses = GenericToll.find_by_sql(['SELECT * FROM generic_tolls where Generic_Tolls.truck_id = ? AND
                  generic_tolls."StartDate" BETWEEN ? AND ? ORDER BY 
                  generic_tolls."StartDate" ASC', @truck_id, date_from1, date_to1 ])
               if  @genericTollExpenses
                 arrayGenericToll.concat(@genericTollExpenses)
               end 
          end

          if DriverExpense.all.size
                @driverExpenses = DriverExpense.find_by_sql(['SELECT * FROM driver_expenses where 
                  driver_expenses.truck_id = ? AND driver_expenses."DATE" BETWEEN ? AND ?', @truck_id,
                  date_from1, date_to1])

                if @driverExpenses
                arrayDriverExpenses.concat(@driverExpenses)
                end
          end

          if InvoicedTrip.all.size > 0
         #   @invoicedTrips = InvoicedTrip.find_by_sql(['SELECT * FROM invoiced_trips where invoiced_trips.truck_id = ? AND
         #             invoiced_trips."StartDate" >= ? AND invoiced_trips."EndDate" <= ?', @truck_id, date_from1, date_to1])

      @invoicedTrips = InvoicedTrip.find_by_sql(['SELECT * FROM invoiced_trips where invoiced_trips.truck_id = ? AND
                      invoiced_trips."StartDate" > ? AND invoiced_trips."StartDate" <= ?', @truck_id, date_from1-1, date_to1])


             if @invoicedTrips.size > 0

              
              arrayInvoicedTrips.concat(@invoicedTrips)
             end
          end 

          if FuelExpense.all.size
              @fuelExpenses = FuelExpense.find_by_sql(["SELECT * FROM fuel_expenses where fuel_expenses.truck_id = ? AND
                fuel_expenses.trsdate BETWEEN ? AND ? ORDER BY 
                fuel_expenses.trsdate ASC", @truck_id, date_from1, 
                date_to1])
              arrayFuelExpenses.concat(@fuelExpenses)
          end




else
#drivers

              @localEvent = Event.find_by_sql(['SELECT * FROM events where events."DRIVER_id" = ? 
              and events."DATE" BETWEEN ? AND ? ORDER BY events."DATE" ASC', @driver_id, date_from1, date_to1])






              if @localEvent.count > 0 
                  if @localEvent.count%2 == 1
                            if @localEvent[0].START_END == true
                               #append at the end the date_to1 as it comes from the form interval
                               @localEvent.push(@localEvent[@localEvent.count-1].dup)
                               @localEvent[@localEvent.count-1].id = @localEvent.count
                               @localEvent[@localEvent.count-1].DATE = to_datetime(date_to1)
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
                               @localEvent[@localEvent.count-1].DATE = to_datetime(date_to1)
                               @localEvent[@localEvent.count-1].START_END = false    
                             end
                  end
              else
                
                  #In this case it is still possible that the interval has started before @date_from. 
                  @localEvent = Event.find_by_sql(['SELECT * FROM events where events."DRIVER_id" = ? 
                     and events."DATE" <= ? ORDER BY events."DATE" DESC', @driver_id, date_from1])


                      if  @localEvent.size >0 and @localEvent[0].START_END == true


                            truck_id_l = @localEvent[0].truck_id
                            @localEvent = Array.new(2) { Event.new }
                            @localEvent[0].START_END = true
                            @localEvent[0].truck_id = truck_id_l
                            @localEvent[0].DATE = date_from1
                            @localEvent[1].START_END = false
                            @localEvent[1].DATE = to_datetime(date_to1)   




                      else
                         @localEvent = nil
                      end
                end
       


    if @localEvent != nil

          1.upto( @localEvent.count/2) do |i|
                #truck_id = 0 means the truck_id is irrelevant
                    if TruckExpense.all.size
                          @truckExpense = TruckExpense.find_by_sql(['SELECT * FROM Truck_Expenses where 
                          Truck_Expenses.truck_id = ? AND Truck_Expenses."DATE" BETWEEN ? AND ? ORDER BY 
                          Truck_Expenses."DATE" ASC', @localEvent[2*(i-1)].truck_id, @localEvent[2*(i-1)].DATE-1, 
                          @localEvent[2*(i-1)+1].DATE+1])

                          arrayTruckExpense.concat(@truckExpense)
                    end
#in case the ApplicationRecord has datetime field then dont use -1, otherwise us
                    if DeToll.all.size
                        @germanyTollExpenses = DeToll.find_by_sql(["SELECT * FROM de_tolls where 
                          de_tolls.truck_id = ? AND de_tolls.datetime BETWEEN ? AND ? ORDER BY 
                          de_tolls.date ASC", @localEvent[2*(i-1)].truck_id, @localEvent[2*(i-1)].DATE, 
                          @localEvent[2*(i-1)+1].DATE ])
                          arrayGermanyToll.concat(@germanyTollExpenses)                          
                    end

                    if BeToll.all.size
                        @belgiumTollExpenses = BeToll.find_by_sql(['SELECT * FROM be_tolls where 
                          be_tolls.truck_id = ? AND be_tolls.datetime >= ? AND be_tolls.datetime <= ? ORDER BY 
                          be_tolls.date_of_usage ASC', @localEvent[2*(i-1)].truck_id,@localEvent[2*(i-1)].DATE, 
                          @localEvent[2*(i-1)+1].DATE ]) 
                         arrayBeToll.concat(@belgiumTollExpenses)
 

#if @driver_id == 6

#asdasd1

# end

                    end

                    if GenericToll.all.size
                        @genericTollExpenses = GenericToll.find_by_sql(['SELECT * FROM Generic_Tolls where 
                            Generic_Tolls.truck_id = ? AND Generic_Tolls."StartDate" BETWEEN ? AND ? ORDER BY 
                          Generic_Tolls."StartDate" ASC', @localEvent[2*(i-1)].truck_id, @localEvent[2*(i-1)].DATE, 
                          @localEvent[2*(i-1)+1].DATE ])
                         arrayGenericToll.concat(@genericTollExpenses)
                    end

                    if FuelExpense.all.size
                        @fuelExpenses = FuelExpense.find_by_sql(["SELECT * FROM fuel_expenses where 
                          fuel_expenses.truck_id = ? AND fuel_expenses.datetime BETWEEN ? AND ? ORDER BY 
                          fuel_expenses.datetime ASC", @localEvent[2*(i-1)].truck_id, @localEvent[2*(i-1)].DATE, 
                          @localEvent[2*(i-1)+1].DATE ])
                        arrayFuelExpenses.concat(@fuelExpenses)
                    end

                    if DriverExpense.all.size
                        @driverExpenses = DriverExpense.find_by_sql(['SELECT * FROM driver_expenses where 
                          driver_expenses.truck_id = ? AND 
                          driver_expenses."DATE" BETWEEN ? AND ? ORDER BY 
                          driver_expenses."DATE"',  @localEvent[2*(i-1)].truck_id, @localEvent[2*(i-1)].DATE, @localEvent[2*(i-1)+1].DATE ])
                        arrayDriverExpenses.concat(@driverExpenses)
                    end


              end



    end




          if InvoicedTrip.all.size > 0
         #   @invoicedTrips = InvoicedTrip.find_by_sql(['SELECT * FROM invoiced_trips where invoiced_trips.truck_id = ? AND
         #             invoiced_trips."StartDate" >= ? AND invoiced_trips."EndDate" <= ?', @truck_id, date_from1, date_to1])

             @invoicedTrips = InvoicedTrip.find_by_sql(['SELECT * FROM invoiced_trips where invoiced_trips."DRIVER_id" = ? AND
                      invoiced_trips."StartDate" > ? AND invoiced_trips."StartDate" <= ?', @driver_id, date_from1-1, date_to1+1])




             if @invoicedTrips.size > 0

              
              arrayInvoicedTrips.concat(@invoicedTrips)
             end


             if @driver_id > 1




@totalTruckExpense = 0
if  arrayTruckExpense != nil
    1.upto( arrayTruckExpense.count) do |i|
        @totalTruckExpense = @totalTruckExpense.to_d + arrayTruckExpense[i-1].AMOUNT.to_d
    end
end    

@totalGermanyToll = 0
if  arrayGermanyToll != nil
    1.upto( arrayGermanyToll.count) do |i|
        @totalGermanyToll = @totalGermanyToll.to_d + arrayGermanyToll[i-1].eur.to_d
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
        @totalFuelExpenses = @totalFuelExpenses.to_d + arrayFuelExpenses[i-1].EuroNetAmountInclVATFreeCharges.to_d
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


@total_debit = @totalInvoicedTrips- (@totalTruckExpense.to_d + @totalGermanyToll.to_d + @totalBeToll.to_d +
               @totalGenericToll.to_d + @totalDriverExpenses.to_d + @totalFuelExpenses.to_d) 



if @driver_id == 23
   #s      asdasda
end
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
        @totalGermanyToll = @totalGermanyToll.to_d + arrayGermanyToll[i-1].eur.to_d
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
        @totalFuelExpenses = @totalFuelExpenses.to_d + arrayFuelExpenses[i-1].EuroNetAmountInclVATFreeCharges.to_d
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


@total_debit = @totalInvoicedTrips- (@totalTruckExpense.to_d + @totalGermanyToll.to_d + @totalBeToll.to_d +
               @totalGenericToll.to_d + @totalDriverExpenses.to_d + @totalFuelExpenses.to_d) 



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

  def parsed_time_interval (n1, default)
    n1.to_i
    rescue ArgumentError, TypeError
    default.to_i
  end

  def parsed_trucks_drivers (n1, default)
    n1.to_i
    rescue ArgumentError, TypeError
    default

  end

   def parsed_clients (n1, default)
    n1.to_i
    rescue ArgumentError, TypeError
    default

  end

  def parsed_period (n1, default)
    n1.to_i
    rescue ArgumentError, TypeError
    default
  end

  def parsed_active (n1, default)
    n1.to_i
    rescue ArgumentError, TypeError
    default
  end

  def parsed_invoices_salaries (n1, default)
    n1.to_i
    rescue ArgumentError, TypeError
    default

  end

private

  def parsed_date (date_string, default)
    Date.parse(date_string).strftime('%Y-%m-%d')
    rescue ArgumentError, TypeError
    default
  end

end 
  
