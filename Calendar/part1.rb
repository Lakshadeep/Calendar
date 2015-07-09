require 'date'
require 'io/console'

days7 = %w[sun mon tue wed thu fri sat]

def get_today_info
	time = Time.new
	weekday = time.wday
	month = time.month
	year = time.year
	return [weekday,month,year]
end


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

$weekdays = {
  0  => 'Mon',
  1  => 'Tue',
  2  => 'Wed',
  3  => 'Thu',
  4  => 'Fri',
  5  => 'Sat',
  6  => 'Sun'
}


def create_calendar(month,year,day_format,last_day)
	$day = 1
	$month_array = Array.new(7){Array.new(6)}
	

	for i in 0..5
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

	headers_dispaly(weekday,start_day)
	
	puts "\n"

	for i in 0..6
	
		puts x[i].join(' ')
	
	end
end



$x = '1'
$day_from = 0
$today = get_today_info

while $x != 'q' do
	
	puts("\n")
	puts("To go to next month press N\n")
	puts("To go to previous month press P\n")
	puts("\n")
	
	

	if $x == '1'
		last_day = get_days_in_month($today[1],$today[2])
		display_calendar(create_calendar($today[1],$today[2],0,last_day),days7,0)
		$x = STDIN.getch
	elsif $x.eql?"p"
		
		$today[1] = $today[1] - 1
		if $today[1] <= 0
			$today[1] = 12
			$today[2] = $today[2] - 1
		end
		last_day = get_days_in_month($today[1],$today[2])
		display_calendar(create_calendar($today[1],$today[2],0,last_day),days7,0)
		$x = STDIN.getch
	elsif $x.eql?"n"
		$today[1] = $today[1] + 1
		if $today[1] >= 13
			$today[1] = 1
			$today[2] = $today[2] + 1
		end
		
		last_day = get_days_in_month($today[1],$today[2])
		display_calendar(create_calendar($today[1],$today[2],0,last_day),days7,0)
		$x = STDIN.getch
	else

		
		$x = STDIN.getch


	end

end		
