
require 'csv'
require 'nokogiri'

class BookmarkLinkParser < Nokogiri::XML::SAX::Document
  attr_accessor :html

  def initialize(html)
    self.html = html
  end

  def call
    reader = FirefoxLinkParser.new

    parser = Nokogiri::HTML::SAX::Parser.new(reader)

    parser.parse(html)

    reader.link_list
  end
end

class FirefoxLinkParser < Nokogiri::XML::SAX::Document
  attr_accessor :link_list

  def initialize
    @link = false
    @h3 = false

    self.link_list = []
  end

  def start_element(name, attributes=[])
    if name == 'a'
      url = Hash[attributes]['href']
      @url = url.index('http') ? url : nil
      @link = true
    elsif name == 'h3'
      @h3 = true
    end
  end

  def characters(content)
    if @link
      @content = content
    elsif @h3
      @tag = content
    end
  end

  def end_element(name)
    if name == 'a'
      self.link_list << [ @url, @tag, @content ] if @url

      @link = false
    elsif name == 'h3'
      @h3 = false
    end
  end

  def end_document
  end
end

