require 'date'

date_string = '2025-04-29'
date = Date.strptime(date_string, "%Y-%m-%d")
formatted_date = date.strftime("%d %B %Y")
puts formatted_date
