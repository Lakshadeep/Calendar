require 'date'
require 'io/console'
require 'optparse'
require 'csv'

def get_days_in_month(month,year) 
	time = Date.new(year,month,-1)
    no_of_days = time.day
    return no_of_days
end

$holidays_list = []
if File.exist?('holidays.csv')
	CSV.foreach('holidays.csv') do |row|
  		$holidays_list.push(row)
	end
	for i in 0..$holidays_list.length-1
		$holidays_list[i][0]= DateTime.parse($holidays_list[i][0]).to_date
	end
else
	puts()
	puts "Couldn't find holidays.csv file"
	puts()
end
	



def display_calendar(date,first_dow,append_info,plugin_switch)
	day = 1
	c_month = date.mon
	c_year = date.year
	l_month = (date << 1).mon
	l_year = (date << 1).year
	n_month = (date >> 1).mon
	n_year = (date >> 1).year

	m_temp = Date::ABBR_MONTHNAMES
	months = m_temp[1,13]
	days7 = Date::ABBR_DAYNAMES

	printf("%25s","#{ months[c_month-1]}, #{c_year.to_s}\n")
	headers_display(days7,first_dow)
	last_day = get_days_in_month(date.mon,date.year)
	start_day = 0 

	for k in 0..6
		if ((k+first_dow)%7) == (Date.new(date.year,date.mon,day)).wday
			start_day = k
			break
		end
	end

	lm = date << 1
	last_month_nod = get_days_in_month(lm.mon,lm.year)
	last_month_offset = (Date.new(date.year,date.mon,1)).wday - first_dow
	if last_month_offset < 0
		last_month_offset = (7 + last_month_offset)
	end

	next_month_offset = 1

	for i in 0..5
		for j in 0..6
			if day <= last_day and j >= start_day  and  i ==0
				printf("%5s",day.to_s+ append_info.call(Date.new(date.year,date.mon,day),c_month,plugin_switch))
				day = day + 1
			elsif day <= last_day and i!=0
				printf("%5s",day.to_s + append_info.call(Date.new(date.year,date.mon,day),c_month,plugin_switch)) 
				day = day + 1
			elsif i == 0
				last_month_day = last_month_nod - last_month_offset+j+1
				printf("%5s",last_month_day.to_s+ append_info.call(Date.new(l_year,l_month,last_month_day),c_month,plugin_switch))
			else
				next_month_day = next_month_offset 
				printf("%5s",next_month_offset.to_s+ append_info.call(Date.new(n_year,n_month,next_month_day),c_month,plugin_switch)) 
				next_month_offset = next_month_offset + 1
			end
		end
		puts()	
	end

	
end

def headers_display(weekday,start_dow)
	puts("  #{weekday[start_dow%7]}  #{weekday[(start_dow+1)%7]}  #{weekday[(start_dow+2)%7]}  #{weekday[(start_dow+3)%7]}  #{weekday[(start_dow+4)%7]}  #{weekday[(start_dow+5)%7]}  #{weekday[(start_dow+6)%7]}")
end

append_info = lambda{|date,curr_month,plugin_switch|
	star_plugin = lambda{|date,curr_month|
		if date.mon != curr_month
			return "*"
		else
			return ""
		end
 	}

 	holiday_plugin = lambda{|date,curr_month|
 		ch ="a"

		for i in 0..$holidays_list.length-1
			if $holidays_list[i][0].mon == curr_month
				if $holidays_list[i][0] == date
					return ch
				else
					ch = ch.next
				end
			end
			
		end	
		return " "
	}
 	
	if plugin_switch.eql? "star_plugin"
		star_plugin.call(date,curr_month)
	elsif plugin_switch.eql? "holiday_plugin"
		holiday_plugin.call(date,curr_month)
	elsif plugin_switch.eql?"both"
		temp1 = star_plugin.call(date,curr_month)
		temp2 = holiday_plugin.call(date,curr_month)
		return temp1+temp2
	else
		return ""
	end
}


def print_holidays(month,year)
	ch ="a"
	for i in 0..$holidays_list.length-1
		if $holidays_list[i][0].mon == month and $holidays_list[i][0].year == year 
 			puts(ch+":"+$holidays_list[i][1])
			ch = ch.next
		end
	end	
end

#main program starts from here
$first_dow = 0
$today = Date.today
options = {}

optparse = OptionParser.new do |opts|
  opts.on('-m', '--m MONTH', "Mandatory MONTH") do |f|
    options[:month] = f
  end
  opts.on('-y', '--y YEAR', "Mandatory YEAR") do |f|
    options[:year] = f
  end
  opts.on('-w', '--w STARTDAY', "Optional STARTDAY") do |f|
    options[:first_dow] = f
  end
  opts.on('-h', '--hHOLIDAY', "Optional HOLIDAY") do |f|
    options[:holiday] = f
  end
end

optparse.parse!

if !options[:month] or !options[:year]
	puts "Error- Month and year are mandatory"
else
	if options[:first_dow]
		$first_dow = options[:first_dow].to_i
	end
	if options[:holidays]
		display_calendar($today,$first_dow,append_info,"both")
		print_holidays($today.mon,$today.year)
	else
		display_calendar($today,$first_dow,append_info,"star_plugin")
	end
end
