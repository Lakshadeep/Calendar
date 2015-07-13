require 'date'
require 'io/console'

def get_days_in_month(month,year) 
	time = Date.new(year,month,-1)
    no_of_days = time.day
    return no_of_days
end

# REVIEW -- this should probably be called 'display_calendar'. Should probably
# be called 'start_dow' instead of 'start_day'                                   --fixed
def display_calendar(date,first_dow,append_info)
	day = 1
	c_month = date.mon
	c_year = date.year
	
	# REVIEW -- You can get these names from the Date class itself    --fixed
	m_temp = Date::ABBR_MONTHNAMES
	months = m_temp[1,13]
	days7 = Date::ABBR_DAYNAMES

	# REVIEW -- use the #{} string interpolation instead of using + to
	# concatenate. eg "My name is #{name}". Why haven't you used printf to align   --fixed
	# output?
	printf("%25s","#{ months[c_month-1]}, #{c_year.to_s}\n")
	headers_display(days7,first_dow)
	last_day = get_days_in_month(date.mon,date.year)
	start_day = 0 
	
	# REVIEW -- why is this condition being evaluated everytime inside the
				# loop?                                                       --fixed
	for i in 0..6
		if ((i+first_dow)%7) == (Date.new(date.year,date.mon,day)).wday
			start_day = i
			break
		end
	end

	for i in 0..5
		for j in 0..6
			# REVIEW -- try to prevent nested if conditions. Try converting them to
			# if-elsif blocks                                                       --fixed

			if day <= last_day and j >= start_day  and  i ==0
				printf("%5s",day.to_s + append_info.call(Date.new(date.year,date.mon,day),first_dow,last_day,i,j,day))
				day = day + 1
			elsif day <= last_day and i!=0
				printf("%5s",day.to_s + append_info.call(Date.new(date.year,date.mon,day),first_dow,last_day,i,j,day))
				day = day + 1
			elsif i == 0
				printf("%5s","" + append_info.call(Date.new(date.year,date.mon,day),first_dow,last_day,i,j,day)) 
			else
				printf("%5s","" + append_info.call(Date.new(date.year,date.mon,last_day),first_dow,last_day,i,j,day)) 
				day = day + 1
			end
		end
		puts()	
	end
	
end

def headers_display(weekday,start_dow)
	puts("  #{weekday[start_dow%7]}  #{weekday[(start_dow+1)%7]}  #{weekday[(start_dow+2)%7]}  #{weekday[(start_dow+3)%7]}  #{weekday[(start_dow+4)%7]}  #{weekday[(start_dow+5)%7]}  #{weekday[(start_dow+6)%7]}")
end


append_info = lambda{|date,first_dow,last_day,i,j,next_month_offset|
	if date.day == 1 and j != date.wday
		lm = date << 1
		first_dow = first_dow + j
		# REVIEW -- No point creating temporary variable for a single use.   --fixed
		last_month_nod = get_days_in_month(lm.mon,lm.year)
		last_month_offset = (Date.new(date.year,date.mon,1)).wday - first_dow
		if last_month_offset < 0
			last_month_offset = (7 + last_month_offset)
			return (last_month_offset - last_month_offset + 1).to_s+"*"
		else
			# REVIEW -- what's happening here?                              --fixed
			return (last_month_nod - last_month_offset + 1).to_s+"*"
		end
	elsif next_month_offset > last_day and 
		
		return (next_month_offset - last_day ).to_s+"*"
	
	else
		return " "
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
	puts("To quit the program press q \n")
	puts("\n")

	if $x.eql?"p"
		$today = $today << 1
	elsif $x.eql?"n"
		$today = $today >> 1
	end
	
	display_calendar($today,$day_form,append_info)
	$x = STDIN.getch  
	puts "\e[H\e[2J"
end		
