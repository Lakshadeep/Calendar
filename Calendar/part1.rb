require 'date'

days7 = %w[sun mon tue wed thu fri sat]

def get_today_info
	time = Time.new
	weekday = time.wday
	month = time.month
	year = time.year
	return [weekday,month,year]
end

#puts get_today_info


def get_days_in_month(month,year) 
	time = Date.new(year,month,-1)
    no_of_days = time.day
    #puts time
    return no_of_days

end

def get_weekday(month,year,dayx)
	x = Date.new(year,month,dayx)
	dayp = x.wday
	return dayp
end

#puts get_days_in_month(2,2004)

$weekdays = {
  0  => 'Mon',
  1  => 'Tue',
  2  => 'Wed',
  3  => 'Thu',
  4  => 'Fri',
  5  => 'Sat',
  6  => 'Sun'
}

#puts weekdays[(1%7)]


def create_calendar(month,year,day_format,last_day)
	$day = 1
	$month_array = Array.new(7){Array.new(5)}
	

	for i in 0..4
		for j in 0..6
			if $day <= last_day
				if ((j+day_format)%7) == get_weekday(month,year,$day)
					if $day < 10
						$month_array[i][j] = "  "+$day.to_s
					else
						$month_array[i][j] = " "+$day.to_s
					end
					$day = $day + 1
				else
					$month_array[i][j] = "   "
				end
			end
		end
	end
	return $month_array
end

def headers_dispaly(weekday,start)
	puts(weekday[start%7]+ " "+weekday[(start+1)%7]+ " "+weekday[(start+2)%7]+ " "+weekday[(start+3)%7]+ " "+weekday[(start+4)%7]+ " "+weekday[(start+5)%7]+ " "+weekday[(start+6)%7])
end

def display_calendar(x,weekday,start_day)
	
	#puts weekday.join(' ')
	headers_dispaly(weekday,start_day)
	
	puts "\n"

	for i in 0..4
	
		puts x[i].join(' ')
	
	end
end

display_calendar(create_calendar(7,2015,4,31),days7,4)

#puts get_weekday(7,2015,1)

#headers_dispaly(days7,2)