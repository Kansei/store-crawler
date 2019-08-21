require_relative './store_crawler'

class TabelogCrawler < StoreCrawler
  def initialize(prefecture: '', area: '' )
    @uri = 'https://tabelog.com'
    super
  end

  def perform
    @page = @agent.get(@uri)
    self.narrow_down_store

    loop do
      store_list = self.get_store_list

      stores = store_list.map do |store_element|
        self.get_store_info(store_element)
      end

      self.write(stores)

      break unless self.go_to_next_page
    end
  end

  def narrow_down_store
    search_form = @page.form_with(name: 'FrmSrchFreeWord')
    search_form.sa = @area
    @page = @agent.submit(search_form)
  end

  def go_to_next_page
    next_element = @page.search('.c-pagination__arrow')

    return false if next_element.length == 0

    @page = @agent.get(next_element.attribute('href').value)
    return true
  end


  def get_store_list
    @page.search("a.list-rst__rst-name-target")
  end

  def get_store_info(store_element)
    store_page = @agent.get(store_element.attribute('href').value)
    table =  store_page.search('table.c-table')
    rows = table.search('tr')

    store = Store.new()

    rows.each do |row|
      th = row.at('th').text
      td = row.at('td').text.strip
      if th.include? '店名'
        store.name = td
      elsif th.include? 'ジャンル'
        store.type = td
      elsif th.include? '住所'
        store.address = td.split("\n").first
      elsif th.include? '営業時間'
        store.open_time = td
      end
    end

    store
  end

  def write(stores)
    CSV.open(@path+@filename+@extension,'a') do |file|
      stores.each do |store|
        file << [store.name, store.type, store.open_time,  store.address]
      end
    end
  end
end
