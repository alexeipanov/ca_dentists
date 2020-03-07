require_relative 'lib/parser'

def url(page_number)
  "https://www.odacentral.ca/Apps/Pages/find-a-dentist?filter=true&directoryType=23171&ParticipantOfNodeId=17107&pageNumber=#{page_number}&contactId=0&filterParticipantTypeNodeId=17039"
end

output = File.open('data/dentists.dat', 'w')
(1..3).each do |page_number|
  page = Parser.new(url(page_number))
  page.load
  page.parse
  output.puts(page.to_text)
end
output.close
