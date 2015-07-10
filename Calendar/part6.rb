require 'date'
require 'io/console'
require 'optparse'

$holidays_list = [[1,1,2015,"Happy New Year",""],
				 [26,1,2015,"Republic Day",""],
				 [19,4,2015,"My Birthday",""],	
				 [19,7,2015,"Ramzan",""],
				 [31,7,2015,"Jamat Ul Vida",""],
				 [15,8,2015,"Independence Day",""],
				 [28,8,2015,"Onam",""],
				 [17,9,2015,"Ganesh Chaturthi",""],
				 [22,10,2015,"Dussehra",""],
				 [11,11,2015,"Diwali",""],
				 [25,12,2015,"Christmas day",""],
				 [1,1,2016,"Happy New Year",""],
				 [26,1,2016,"Republic Day",""]]

days7 = %w[ sun  mon  tue  wed  thu  fri  sat]

def get_holiday_list(month ,year,holidays)
	temp = []
	ch = 65
	for i in 0..holidays.length-1
		if holidays[i][1] == month and holidays[i][2] == year
			holidays[i][4] = ch
			ch = ch + 1
			temp.push(holidays[i])
		end
		
	end
	return temp 
end

def holiday_print(holiday_l,day)
	space = 32
	if holiday_l.length != 0
		for i in 0..holiday_l.length-1
			if holiday_l[i][0] == day
				return holiday_l[i][4]
			
				
			end
		end

	end
	return space
end


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

	#part 4 update
	holidays = get_holiday_list(month,year,$holidays_list)


	for i in 0..5
		for j in 0..6
			if $day <= last_day
				if ((j+day_format)%7) == get_weekday(month,year,$day)
					if $day < 10
						$month_array[i][j] = "  "+$day.to_s+holiday_print(holidays,$day).chr
					else
						$month_array[i][j] = " "+$day.to_s+holiday_print(holidays,$day).chr
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

def display_calendar(x,weekday,start_day,month,year)
	months = %w[Jan Feb Mar Apr May Jun Jul Aug Sept Oct Nov Dec]
	puts("             "+months[month-1] +"  "+ year.to_s)
	headers_dispaly(weekday,start_day)
	
	puts "\n"

	for i in 0..6
	
		puts x[i].join(' ')
	
	end

	holidays = get_holiday_list(month,year,$holidays_list)
	for i in 0..holidays.length-1
		puts(holidays[i][4].chr + " " + holidays[i][3])
		puts("\n")
	end
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: part6.rb [options]"

  opts.on("-m", "--month", "Month") do |month|
    options[:month] = month
  end

  opts.on("-y", "--year", "Year") do |year|
    options[:year] = year
  end
  opts.on("-w", "--day_specifier", "Day") do |day|
    options[:day] = day
  end
end.parse!


if !options[:year] or !options[:year] or ARGV[0].nil? or ARGV[1].nil?
	puts("Error: Invalid inputs")
else
	month = ARGV[0].to_i
	year = ARGV[1].to_i
	last_day = get_days_in_month(month,year)

	if options[:day] and !ARGV[2].nil?
		day_form = ARGV[2].to_i
	else
		day_form = 0
	end

	x = create_calendar(month,year,day_form,last_day)

	display_calendar(x,days7,day_form,month,year)
end




