require 'mechanize'
require 'csv'

class StoreCrawler
  attr_accessor :page, :ku, :area

  def initialize(prefecture: '', city: '', area: '')
    @prefecture = prefecture
    @city = city
    @area = area

    @uri = 'https://tabelog.com'
    @agent = Mechanize.new
  end

  def perform
    raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def scrape
    raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def narrow_down_store
    raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def go_to_next_page
    raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end


  def get_store_list
    raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def get_store_info(store_element)
    raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def write(stores)
    raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def create_list_file
    raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end
end
