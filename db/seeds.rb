# require 'httparty'

# puts 'create regions'
# Region.create!(name: { ru: 'Африка', en: 'Africa' })
# Region.create!(name: { ru: 'Азия', en: 'Asia' })
# Region.create!(name: { ru: 'Европа', en: 'Europe' })
# Region.create!(name: { ru: 'Южная Америка', en: 'South America' })
# Region.create!(name: { ru: 'Северная Америка', en: 'North America' })
# Region.create!(name: { ru: 'Австралия и Океания', en: 'Australia and Oceania' })
# Region.create!(name: { ru: 'Антарктида', en: 'Antarctica' })
# puts 'done!'

# puts 'create subregions'
# Subregion.create!(name: { ru: 'Восточная Африка', en: 'East Africa' }, region: Region.first)
# Subregion.create!(name: { ru: 'Западная Африка', en: 'West Africa' }, region: Region.first)
# Subregion.create!(name: { ru: 'Центральная Африка', en: 'Central Africa' }, region: Region.first)
# Subregion.create!(name: { ru: 'Южная Африка', en: 'South Africa' }, region: Region.first)
# Subregion.create!(name: { ru: 'Северная Африка', en: 'North Africa' }, region: Region.first)
# Subregion.create!(name: { ru: 'Восточная Азия', en: 'East Asia' }, region: Region.second)
# Subregion.create!(name: { ru: 'Западная Азия', en: 'West Asia' }, region: Region.second)
# Subregion.create!(name: { ru: 'Центральная Азия', en: 'Central Asia' }, region: Region.second)
# Subregion.create!(name: { ru: 'Южная Азия', en: 'South Asia' }, region: Region.second)
# Subregion.create!(name: { ru: 'Юго-Восточная Азия', en: 'Southeast Asia' }, region: Region.second)
# Subregion.create!(name: { ru: 'Восточная Европа', en: 'Eastern Europe' }, region: Region.third)
# Subregion.create!(name: { ru: 'Западная Европа', en: 'Western Europe' }, region: Region.third)
# Subregion.create!(name: { ru: 'Центральная Европа', en: 'Central Europe' }, region: Region.third)
# Subregion.create!(name: { ru: 'Южная Европа', en: 'Southern Europe' }, region: Region.third)
# Subregion.create!(name: { ru: 'Юго-Восточная Европа', en: 'Southeast Europe' }, region: Region.third)
# Subregion.create!(name: { ru: 'Северная Европа', en: 'Northern Europe' }, region: Region.third)
# Subregion.create!(name: { ru: 'Южная Америка', en: 'South America' }, region: Region.fourth)
# Subregion.create!(name: { ru: 'Центральная Америка', en: 'Central America' }, region: Region.fifth)
# Subregion.create!(name: { ru: 'Северная Америка', en: 'North America' }, region: Region.fifth)
# Subregion.create!(name: { ru: 'Карибские острова', en: 'Caribbean' }, region: Region.fifth)
# Subregion.create!(name: { ru: 'Микронезия', en: 'Micronesia' }, region: Region.find(6))
# Subregion.create!(name: { ru: 'Полинезия', en: 'Polynesia' }, region: Region.find(6))
# Subregion.create!(name: { ru: 'Австралия и Новая Зеландия', en: 'Australia and New Zealand' }, region: Region.find(6))
# Subregion.create!(name: { ru: 'Меланезия', en: 'Melanesia' }, region: Region.find(6))
# Subregion.create!(name: { ru: 'Антарктида', en: 'Antarctica' }, region: Region.last)
# puts 'done!'

# puts 'start creating countries'
# puts 'create East Africa countries'
# url = 'https://restcountries.com/v3.1/subregion/Eastern%20Africa'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(1))
# end

# puts 'create West Africa countries'
# url = 'https://restcountries.com/v3.1/subregion/Western%20Africa'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(2))
# end

# puts 'create Central Africa countries'
# url = 'https://restcountries.com/v3.1/subregion/Middle%20Africa'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(3))
# end

# puts 'create South Africa countries'
# url = 'https://restcountries.com/v3.1/subregion/Southern%20Africa'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(4))
# end

# puts 'create North Africa countries'
# url = 'https://restcountries.com/v3.1/subregion/Northern%20Africa'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(5))
# end

# puts '==================================='

# puts 'create East Asia countries'
# url = 'https://restcountries.com/v3.1/subregion/Eastern%20Asia'
# res = HTTParty.get(url)
# data = res.parsed_response
# ea_countries = [ data[1], data[2], data[5], data[8], data[12], data[14], data[16], data[18] ]
# ea_countries.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(6))
# end

# puts 'create West Asia countries'
# url = 'https://restcountries.com/v3.1/subregion/Western%20Asia'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(7))
# end

# puts 'create Central Asia countries'
# url = 'https://restcountries.com/v3.1/subregion/Central%20Asia'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(8))
# end

# puts 'create South Asia countries'
# url = 'https://restcountries.com/v3.1/subregion/Southern%20Asia'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(9))
# end

# puts 'create Southeast Asia countries'
# url = 'https://restcountries.com/v3.1/subregion/South-eastern%20Asia'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(10))
# end

# puts '==================================='

# puts 'create Eastern Europe countries'
# url = 'https://restcountries.com/v3.1/subregion/Eastern%20Europe'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(11))
# end

# puts 'create Western Europe countries'
# url = 'https://restcountries.com/v3.1/subregion/Western%20Europe'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(12))
# end

# puts 'create Central Europe countries'
# url = 'https://restcountries.com/v3.1/subregion/Central%20Europe'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(13))
# end

# puts 'create Southern Europe countries'
# url = 'https://restcountries.com/v3.1/subregion/Southern%20Europe'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(14))
# end

# puts 'create Southeast Europe countries'
# url = 'https://restcountries.com/v3.1/subregion/Southeast%20Europe'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(15))
# end

# puts 'create Northern Europe countries'
# url = 'https://restcountries.com/v3.1/subregion/Northern%20Europe'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(16))
# end

# puts '==================================='

# puts 'create South America countries'
# url = 'https://restcountries.com/v3.1/subregion/South%20America'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(17))
# end

# puts 'create Central America countries'
# url = 'https://restcountries.com/v3.1/subregion/Central%20America'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(18))
# end

# puts 'create North America countries'
# url = 'https://restcountries.com/v3.1/subregion/North%20America'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(19))
# end

# puts 'create Caribbean countries'
# url = 'https://restcountries.com/v3.1/subregion/Caribbean'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(20))
# end

# puts '==================================='

# puts 'create Micronesia countries'
# url = 'https://restcountries.com/v3.1/subregion/Micronesia'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(21))
# end

# puts 'create Polynesia countries'
# url = 'https://restcountries.com/v3.1/subregion/Polynesia'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(22))
# end

# puts 'create Australia and New Zealand countries'
# url = 'https://restcountries.com/v3.1/subregion/Australia%20and%20New%20Zealand'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(23))
# end

# puts 'create Melanesia countries'
# url = 'https://restcountries.com/v3.1/subregion/Melanesia'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(24))
# end

# puts 'create Antarctica countries'
# url = 'https://restcountries.com/v3.1/region/Antarctic'
# res = HTTParty.get(url)
# data = res.parsed_response
# data.each do |country|
#   ru_name = country['translations']['rus']['common']
#   en_name = country['name']['common']
#   code = country['cca2']
#   flag_url = country['flags']['svg']
#   puts "#{ru_name} - #{en_name} - #{code}"
#   Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, subregion: Subregion.find(25))
# end

# puts 'finish creating countries'
