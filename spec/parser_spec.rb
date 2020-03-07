require_relative '../lib/parser'

RSpec.describe Parser do
  correct_html = %(
    <html>
    <body>
    <div class="col-md-10">
    <div class="resultItem">
    <div><strong>Dr. Carlos Quiñonez</strong></div>
    <div></div>
    <div>Public Health Dentist</div>
    <div id="divContactTags_7539_1"><div>
    </div></div>
    <div><div></div><div>University Of Torontp</div><div>124 Edward St</div><div>Faculty Of Dentistry</div><div>Toronto ON M5G 1G6</div><div></div></div>
    <div>(416) 864-8239</div>
    </div>
    </div>
    </body>
    </html>
  )

  empty_html = %(
    <html>
    <body>
    </body>
    </html>
  )

  it 'handle network error' do
    parser = Parser.new('wrong_url.com')
    parser.load
    expect(parser.html).to be_an_instance_of(StandardError)
  end

  it 'html load OK' do
    parser = Parser.new('https://www.youroralhealth.ca')
    parser.load
    expect(parser.html).to include('</html>')
  end

  it 'html is parsed successfully' do
    parser = Parser.new
    parser.html = correct_html
    parser.parse
    expect(parser.result[0][:name]).to eq 'Dr. Carlos Quiñonez'
    expect(parser.result[0][:title]).to eq 'Public Health Dentist'
    expect(parser.result[0][:address]).to eq 'University Of Torontp124 Edward StFaculty Of DentistryToronto ON M5G 1G6'
    expect(parser.result[0][:phone]).to eq '(416) 864-8239'
  end

  it 'html without items is parsed correctly' do
    parser = Parser.new
    parser.html = empty_html
    parser.parse
    expect(parser.result).to match_array([])
  end
end
