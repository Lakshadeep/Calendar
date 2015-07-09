require 'date'
require 'io/console'

days7 = %w[ sun  mon  tue  wed  thu  fri  sat]

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
    return no_of_days

end

def get_weekday(month,year,dayx)
	x = Date.new(year,month,dayx)
	dayp = x.wday
	return dayp
end

def get_previous_month(month,year)
	if month <= 1
		p_month = 12
		p_year = year - 1
		return [p_month,p_year]
	else
		p_month = month - 1
		p_year = year
		return [p_month,p_year]
	end
end

def get_next_month(month,year)
	if month >= 12
		p_month = 1
		p_year = year + 1
		return [p_month,p_year]
	else
		p_month = month + 1
		p_year = year 
		return [p_month,p_year]
	end
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

	#part 2 update
	temp = get_previous_month(month,year)
	last_month = temp[0]
	last_month_year = temp[1]
	last_month_day = get_days_in_month(last_month,last_month_year)

	last_month_count = get_weekday(month,year,$day) - day_format

	if last_month_count < 0
		last_month_count = (7 + last_month_count)
	else
		last_month_count = last_month_count
	end

	next_month_count = 1
	

	for i in 0..5
		for j in 0..6
			if $day <= last_day
				if ((j+day_format)%7) == get_weekday(month,year,$day)
					if $day < 10
						$month_array[i][j] = "  "+$day.to_s+" "
					else
						$month_array[i][j] = " "+$day.to_s+" "
					end
					$day = $day + 1
				else
					$month_array[i][j] = " "+(last_month_day - last_month_count+1).to_s+"*"
					last_month_count = last_month_count-1
				end
			else
				if next_month_count < 10
					$month_array[i][j] =  "  "+next_month_count.to_s+"*"
					next_month_count = next_month_count + 1
				else
					$month_array[i][j] =  " "+next_month_count.to_s+"*"
					next_month_count = next_month_count + 1
				end
			end
		end
	end
	return $month_array
end

def headers_dispaly(weekday,start)
	puts(" "+weekday[start%7]+ "  "+weekday[(start+1)%7]+ "  "+weekday[(start+2)%7]+ "  "+weekday[(start+3)%7]+ "  "+weekday[(start+4)%7]+ "  "+weekday[(start+5)%7]+ "  "+weekday[(start+6)%7])
end

def display_calendar(x,weekday,start_day)

	headers_dispaly(weekday,start_day)
	
	puts "\n"

	for i in 0..6
	
		puts x[i].join(' ')
	
	end
end



$x = '1'
$day_form = 0
$today = get_today_info

while $x != 'q' do
	puts("\n")
	puts("To go to next month press n\n")
	puts("To go to previous month press p\n")
	puts("To change start-day press w \n")
	puts("\n")
	
	if $x == '1'
		last_day = get_days_in_month($today[1],$today[2])
		display_calendar(create_calendar($today[1],$today[2],$day_form,last_day),days7,$day_form)
		$x = STDIN.getch
	elsif $x.eql?"p"
		temp = get_previous_month($today[1],$today[2])
		$today[1] = temp[0]
		$today[2] = temp[1]
		last_day = get_days_in_month($today[1],$today[2])
		display_calendar(create_calendar($today[1],$today[2],$day_form,last_day),days7,$day_form)
		$x = STDIN.getch
	elsif $x.eql?"n"
		temp = get_next_month($today[1],$today[2])
		$today[1] = temp[0]
		$today[2] = temp[1]	
		last_day = get_days_in_month($today[1],$today[2])
		display_calendar(create_calendar($today[1],$today[2],$day_form,last_day),days7,$day_form)
		$x = STDIN.getch
	elsif $x.eql?"w"
		puts("\n")
		puts("Enter 0 for Sunday\n")
		puts("Enter 1 for Monday\n")
		puts("Enter 2 for Tuesday\n")
		puts("Enter 3 for Wednesday\n")
		puts("Enter 4 for Thursday\n")
		puts("Enter 5 for Friday\n")
		puts("Enter 6 for Saturday\n")
		puts("\n")	
		$day_form = gets.to_i
		puts($day_form)

		puts("\n")
		puts("To go to next month press n\n")
		puts("To go to previous month press p\n")
		puts("To change start-day press w \n")
		puts("\n")	
		$x = STDIN.getch	
	else
		$x = STDIN.getch
	end
end		
