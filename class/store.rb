class Store
  attr_accessor :name, :type, :open_time, :address, :url, :area
  def initialize(name: '', type: '', open_time: '', address: '', area: '', url: '')
    @name = name
    @type = type
    @open_time = open_time
    @address = address
    @area = area
    @url = url
  end
end
