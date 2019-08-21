class Store
  attr_accessor :name, :type, :open_time, :address
  def initialize(name: '', type: '', open_time: '', address: '')
    @name = name
    @type = type
    @open_time = open_time
    @address = address
  end
end
