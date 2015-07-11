require 'date'
require 'io/console'

$holidays_list = [[Date.new(2015,1,1),"Happy New Year",""],
				 [Date.new(2015,1,26),"Republic Day",""],
				 [Date.new(2015,4,19),"My Birthday",""],	
				 [Date.new(2015,7,19),"Ramzan",""],
				 [Date.new(2015,7,31),"Jamat Ul Vida",""],
				 [Date.new(2015,8,15),"Independence Day",""],
				 [Date.new(2015,8,28),"Onam",""],
				 [Date.new(2015,9,17),"Ganesh Chaturthi",""],
				 [Date.new(2015,10,22),"Dussehra",""],
				 [Date.new(2015,11,11),"Diwali",""],
				 [Date.new(2015,12,25),"Christmas day",""],
				 [Date.new(2016,1,1),"Happy New Year",""],
				 [Date.new(2016,1,26),"Republic Day",""]]

def get_days_in_month(month,year) 
	time = Date.new(year,month,-1)
    no_of_days = time.day
    return no_of_days
end

def create_calendar(date,start_day,last_month,holiday_list,holiday_info,holiday_legend)
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
					printf("%5s",day.to_s+holiday_info.call(Date.new(c_year,c_month,day),holidays))
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
	holiday_legend.call(holidays)
	
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
$x = '1'
$day_form = 0
$today = Date.today

while $x != 'q' do
	puts("\n")
	puts("To go to next month press n\n")
	puts("To go to previous month press p\n")
	puts("To change start-day press w \n")
	puts("To quit the program press q \n")
	puts("\n")

	if $x.eql?"p"
		$today = $today << 1
	elsif $x.eql?"n"
		$today = $today >> 1
	elsif $x.eql?"w"
		puts("\n")
		puts("Enter 0,1,2...5 for Sun,Mon,...Sat respectively\n")
		puts("\n")	
		$day_form = gets.to_i
		puts "\e[H\e[2J"
		puts("\n")
		puts("To go to next month press n\n")
		puts("To go to previous month press p\n")
		puts("To change start-day press w \n")
		puts("\n")	
	end
	
	create_calendar($today,$day_form,last_month_info,get_holiday_list,holiday_info,print_hoilday_legends)
	$x = STDIN.getch  
	puts "\e[H\e[2J"
end		
