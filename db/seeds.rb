require 'httparty'
# puts 'create users'
# User.create!(email_address: 'larry@test.com', password_digest: 'test', name: 'Larry')
# User.create!(email_address: 'alisa@test.com', password_digest: 'test', name: 'Alisa')
# puts 'done!'

# puts 'create regions'
# Region.create!(name: { ru: 'Африка', en: 'Africa' }, visited: false)
# Region.create!(name: { ru: 'Азия', en: 'Asia' }, visited: false)
# Region.create!(name: { ru: 'Европа', en: 'Europe' }, visited: false)
# Region.create!(name: { ru: 'Южная Америка', en: 'South America' }, visited: false)
# Region.create!(name: { ru: 'Северная Америка', en: 'North America' }, visited: false)
# Region.create!(name: { ru: 'Австралия и Океания', en: 'Australia and Oceania' }, visited: false)
# Region.create!(name: { ru: 'Антарктида', en: 'Antarctica' }, visited: false)
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

puts 'create countries'
url = 'https://restcountries.com/v3.1/region/Antarctic'
res = HTTParty.get(url)
data = res.parsed_response
# puts data.size
data.each do |country|
  ru_name = country['translations']['rus']['common']
  en_name = country['name']['common']
  code = country['cca2']
  flag_url = country['flags']['svg']
  # puts "#{ru_name} - #{en_name} - #{code}"
  Country.create!(name: { ru: ru_name, en: en_name }, code: code, flag_url: flag_url, visited: false, subregion: Subregion.last)
end
puts 'done'
