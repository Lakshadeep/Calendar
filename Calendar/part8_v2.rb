require 'csv'
require 'date'
require 'io/console'
require 'optparse'

$holidays_list = []
CSV.foreach('holidays.csv') do |row|
  $holidays_list.push(row)
end




def get_days_in_month(month,year) 
	time = Date.new(year,month,-1)
    no_of_days = time.day
    return no_of_days
end

def create_calendar(date,start_day,last_month,holiday_list,holiday_info,holiday_legend,h_flag)
	day = 1
	c_month = date.mon
	c_year = date.year
	months = %w[Jan Feb Mar Apr May Jun Jul Aug Sept Oct Nov Dec]
	days7 = %w[ sun  mon  tue  wed  thu  fri  sat]
	puts("             "+months[c_month-1] +"  "+ c_year.to_s)
	headers_display(days7,start_day)
	last_day = get_days_in_month(date.mon,date.year)
	next_month_count = 1

	holidays = holiday_list.call(date.mon,date.year,$holidays_list)

	for i in 0..5
		for j in 0..6
			if day <= last_day
				if ((j+start_day)%7) == (Date.new(date.year,date.mon,day)).wday
					if h_flag
						printf("%5s",day.to_s+holiday_info.call(Date.new(c_year,c_month,day),holidays))
					else
						printf("%5s",day.to_s)
					end
					day = day + 1
				else
					printf("%5s",last_month.call(date,start_day+j))				
				end
			else
				printf("%5s",next_month_count.to_s+"*")
				next_month_count = next_month_count+1	
				
			end
		end
		puts()	
	end
	if h_flag
		holiday_legend.call(holidays)
	end
	
end

def headers_display(weekday,start)
	puts("  "+weekday[start%7]+ "  "+weekday[(start+1)%7]+ "  "+weekday[(start+2)%7]+ "  "+weekday[(start+3)%7]+ "  "+weekday[(start+4)%7]+ "  "+weekday[(start+5)%7]+ "  "+weekday[(start+6)%7])
end

last_month_info = lambda{|date,start_day|
	lm = date << 1
	l_month = lm.mon
	l_year = lm.year
	last_month_day = get_days_in_month(l_month,l_year)
	last_month_count = (Date.new(date.year,date.mon,1)).wday - start_day
	if last_month_count < 0
		last_month_count = (7 + last_month_count)
	else
		return last_month_count = last_month_count
	end
	return (last_month_day - last_month_count + 1).to_s+"*"
}

holiday_info = lambda{|date,holidays_list|
	space = 32
	for i in 0..holidays_list.length-1
		if date == holidays_list[i][0]
			return holidays_list[i][2].to_s
		end
	end
	return space.chr
}

get_holiday_list = lambda{|month,year,holidays|
	temp = []
	holiday_temp = holidays
	ch = 'a'
	for i in 0..holidays.length-1
		if holidays[i][0].mon == month and holidays[i][0].year == year
			holiday_temp[i][2] = ch
			ch = ch.next
			temp.push(holiday_temp[i])
		end	
	end
	return temp 
}

print_hoilday_legends = lambda{|holidays|
	for i in 0..holidays.length - 1
		puts(holidays[i][2] + ":" + holidays[i][1])
	end
}



#main program starts from here
for i in 0..$holidays_list.length-1
	$holidays_list[i][0]= DateTime.parse($holidays_list[i][0]).to_date
end

$day_form = 0

options = {}


optparse = OptionParser.new do |opts|
  opts.on('-m', '--m MONTH', "Mandatory MONTH") do |f|
    options[:month] = f
  end
  opts.on('-y', '--y YEAR', "Mandatory YEAR") do |f|
    options[:year] = f
  end
  opts.on('-w', '--w STARTDAY', "Optional STARTDAY") do |f|
    options[:day] = f
  end
  opts.on('-h', '--hHOLIDAY', "Optional HOLIDAY") do |f|
    options[:holi] = f
  end
end

optparse.parse!



if !options[:month] or !options[:year]
	puts "Error"
else
	if options[:day]
		$day_form = options[:day].to_i
	end
	if options[:holi]
		create_calendar(Date.new(options[:year].to_i,options[:month].to_i,1),$day_form,last_month_info,get_holiday_list,holiday_info,print_hoilday_legends,true)
	else
		create_calendar(Date.new(options[:year].to_i,options[:month].to_i,1),$day_form,last_month_info,get_holiday_list,holiday_info,print_hoilday_legends,false)
	end
end