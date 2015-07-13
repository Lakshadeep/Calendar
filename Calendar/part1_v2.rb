require 'date'
require 'io/console'

def get_days_in_month(month,year) 
	time = Date.new(year,month,-1)
  no_of_days = time.day
  return no_of_days
end

def create_calendar(date,start_day)
	day = 1
	c_month = date.mon
	c_year = date.year
	
	# REVIEW -- You can get these names from the Date class itself
	months = %w[Jan Feb Mar Apr May Jun Jul Aug Sept Oct Nov Dec]
	days7 = %w[ sun  mon  tue  wed  thu  fri  sat]

	# REVIEW -- use the #{} string interpolation instead of using + to
	# concatenate. eg "My name is #{name}". Why haven't you used printf to align
	# output?
	puts("             "+months[c_month-1] +"  "+ c_year.to_s)
	headers_display(days7,start_day)
	last_day = get_days_in_month(date.mon,date.year)


	for i in 0..5
		for j in 0..6
			# REVIEW -- try to prevent nested if conditions. Try converting them to
			# if-elsif blocks
			if day <= last_day
				# REVIEW -- why is this condition being evaluated everytime inside the
				# loop?
				if ((j+start_day)%7) == (Date.new(date.year,date.mon,day)).wday
					printf("%5s",day.to_s)
					day = day + 1
				else
					printf("%5s","")		
				end
			else
				printf("%5s","")				
			end
		end
		puts()	
	end
	
end

def headers_display(weekday,start)
	puts("  "+weekday[start%7]+ "  "+weekday[(start+1)%7]+ "  "+weekday[(start+2)%7]+ "  "+weekday[(start+3)%7]+ "  "+weekday[(start+4)%7]+ "  "+weekday[(start+5)%7]+ "  "+weekday[(start+6)%7])
end

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
	
	create_calendar($today,$day_form)
	$x = STDIN.getch  
	puts "\e[H\e[2J"
end		
