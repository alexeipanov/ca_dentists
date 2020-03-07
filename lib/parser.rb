class Parser
  require 'nokogiri'
  require 'open-uri'

  attr_reader :result
  attr_accessor :html

  def initialize(url = nil)
    @url = url
    @html = ''
    @result = []
  end

  def dentist
    Struct.new(:name, :title, :address, :phone)
  end

  def load
    @html = URI.open(@url) unless @url.empty?
  rescue StandardError
    @html = StandardError.new
  end

  def parse
    return if @html.instance_of?(StandardError)

    doc = Nokogiri::HTML(@html)
    doc.css('.resultItem').each do |item|
      @result << dentist.new(
        item.at_css('strong').text,
        item.at_css('> div:nth-child(3)').text,
        item.at_css('> div:nth-child(5)').text,
        item.at_css('> div:nth-child(6)').text
      )
    end
  end

  def to_text
    text = ''
    @result.each do |item|
      text += "#{item[:name]};#{item[:title]};#{item[:address]};#{item[:phone]}\n" unless item == dentist.new('', '', '', '')
    end
    text
  end
end
