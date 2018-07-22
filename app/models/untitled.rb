class TransactionSearch 
	attr_reader :date_from, :date_to, :truck_id, :driver_id, :truck_events

	def initialize(params)
		params ||= {}
		@date_from = parsed_date(params[:date_from],300.days.ago.to_date.to_s)
		@date_to = parsed_date(params[:date_to], Date.today.to_s)
    @driver_id = parsed_driver_id(params[:driver_id], 1)
	end

def scope 	
#	return	Event.where('date BETWEEN ? AND ?', @date_from, @date_to),
#           TruckExpense.where('date BETWEEN ? AND ?', @date_from, @date_to),	
#	        DriverExpense.where('date BETWEEN ? AND ?', @date_from, @date_to)

arrayTruckExpense = Array.new
arrayGermanyToll = Array.new
arrayBelgiumToll = Array.new
arrayGenericToll = Array.new

if @driver_id > 0
  @localEvent = Event.find_by_sql(["SELECT * FROM Events where Events.driver_id = ? 
  ORDER BY Events.DATE ASC", driver_id])

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
      truck_events = false 
   end






  puts (@localEvent.count/2).to_s+" >>>".to_s
    1.upto( @localEvent.count/2) do |i|
    #puts @localEvent[2*(i-1)].truck_id
    #puts @localEvent[2*(i-1)+1].truck_id

    @truckExpense = TruckExpense.find_by_sql(["SELECT * FROM Truck_Expenses where 
    	Truck_Expenses.truck_id = ? AND Truck_Expenses.DATE BETWEEN ? AND ? ORDER BY 
    	Truck_Expenses.DATE ASC", @localEvent[2*(i-1)].truck_id, @localEvent[2*(i-1)].DATE, 
    	@localEvent[2*(i-1)+1].DATE ])
    arrayTruckExpense.concat(@truckExpense)

    @germanyTollExpenses = GermanyToll.find_by_sql(["SELECT * FROM Germany_Tolls where 
    	Germany_Tolls.truck_id = ? AND Germany_Tolls.date BETWEEN ? AND ? ORDER BY 
    	Germany_Tolls.date ASC", @localEvent[2*(i-1)].truck_id, @localEvent[2*(i-1)].DATE, 
    	@localEvent[2*(i-1)+1].DATE ])
    arrayGermanyToll.concat(@germanyTollExpenses)

    @belgiumTollExpenses = BelgiumToll.find_by_sql(["SELECT * FROM Belgium_Tolls where 
      Belgium_Tolls.truck_id = ? AND Belgium_Tolls.StartDate BETWEEN ? AND ? ORDER BY 
      Belgium_Tolls.StartDate ASC", @localEvent[2*(i-1)].truck_id, @localEvent[2*(i-1)].DATE, 
      @localEvent[2*(i-1)+1].DATE ])
     arrayBelgiumToll.concat(@belgiumTollExpenses)

    @genericTollExpenses = GenericToll.find_by_sql(["SELECT * FROM Generic_Tolls where 
      Generic_Tolls.truck_id = ? AND Generic_Tolls.StartDate BETWEEN ? AND ? ORDER BY 
      Generic_Tolls.StartDate ASC", @localEvent[2*(i-1)].truck_id, @localEvent[2*(i-1)].DATE, 
      @localEvent[2*(i-1)+1].DATE ])
     arrayGenericToll.concat(@genericTollExpenses)

    @driverExpenses = DriverExpense.where('DRIVER_id = ? AND date BETWEEN ? AND ?', @driver_id, @date_from, @date_to)
    arrayDriverExpenses.concat(@driverExpenses)

    @invoicedTrips = InvoicedTrip.find_by_sql(["SELECT * FROM Invoiced_Trips where Invoiced_Trips.driver_id = ? AND  
            Invoiced_Trips.StartDate > ? AND Invoiced_Trips.EndDate < ?", @driver_id, @date_from, @date_to])
    arrayInvoicedTrips.concat(@invoicedTrips)

   end

else


 @truckExpense = TruckExpense.find_by_sql(["SELECT * FROM Truck_Expenses where 
    Truck_Expenses.DATE BETWEEN ? AND ? ORDER BY 
    Truck_Expenses.DATE ASC", @date_from, @date_to ])
  arrayTruckExpense.concat(@truckExpense)

  @germanyTollExpenses = GermanyToll.find_by_sql(["SELECT * FROM Germany_Tolls where 
    Germany_Tolls.date BETWEEN ? AND ? ORDER BY 
    Germany_Tolls.date ASC", @date_from, @date_to ])
  arrayGermanyToll.concat(@germanyTollExpenses)

  @belgiumTollExpenses = BelgiumToll.find_by_sql(["SELECT * FROM Belgium_Tolls where 
    Belgium_Tolls.StartDate BETWEEN ? AND ? ORDER BY 
    Belgium_Tolls.StartDate ASC", @date_from, @date_to ])
   arrayBelgiumToll.concat(@belgiumTollExpenses)

  @genericTollExpenses = GenericToll.find_by_sql(["SELECT * FROM Generic_Tolls where 
    Generic_Tolls.StartDate BETWEEN ? AND ? ORDER BY 
    Generic_Tolls.StartDate ASC", @date_from, @date_to ])
   arrayGenericToll.concat(@genericTollExpenses)

  @driverExpenses = DriverExpense.where('date BETWEEN ? AND ?',@date_from, @date_to)
  arrayDriverExpenses.concat(@driverExpenses)

  @invoicedTrips = InvoicedTrip.find_by_sql(["SELECT * FROM Invoiced_Trips where   
            Invoiced_Trips.StartDate > ? AND Invoiced_Trips.EndDate < ?", @date_from, @date_to])
  arrayInvoicedTrips.concat(@invoicedTrips)
 

end





	return arrayEvents,Event.find_by_sql(["SELECT * FROM Events where Events.driver_id = ?", driver_id]),
           arrayTruckExpense,
           arrayGermanyToll,
           arrayBelgiumToll,
           arrayGenericToll,
           arrayDriverExpenses,
           arrayInvoicedTrips)



end	

  def parsed_driver_id (n1, default)
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
  
