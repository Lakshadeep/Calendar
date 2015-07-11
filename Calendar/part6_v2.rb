require 'optparse'
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
	months = %w[Jan Feb Mar Apr May Jun Jul Aug Sept Oct Nov Dec]
	days7 = %w[ sun  mon  tue  wed  thu  fri  sat]
	puts("             "+months[c_month-1] +"  "+ c_year.to_s)
	headers_display(days7,start_day)
	last_day = get_days_in_month(date.mon,date.year)


	for i in 0..5
		for j in 0..6
			if day <= last_day
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
end

optparse.parse!


if !options[:month] or !options[:year]
	puts "Error"
else
	if options[:day]
		$day_form = options[:day].to_i
	end


	create_calendar(Date.new(options[:year].to_i,options[:month].to_i,1),$day_form)
end