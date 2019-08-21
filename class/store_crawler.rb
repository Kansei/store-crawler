require 'mechanize'
require 'csv'

class StoreCrawler
  attr_accessor :page

  def initialize(prefecture: '', area: '' )
    @prefecture = prefecture
    @area = area
    @uri = 'https://tabelog.com'

    @agent = Mechanize.new

    @filename = @uri.split("//")[1].split(".")[0]+'_'+@prefecture+'_'+@area
    @extension = '.csv'
    @path = './list/'

    CSV.open(@path+@filename+@extension,'w') do |file|
      file << ["店名", "ジャンル", "営業時間", "住所"]
    end
  end

  def perform
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
end
