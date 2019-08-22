require_relative './store_crawler'

class TabelogCrawler < StoreCrawler
  def initialize(prefecture: '', city: '')
    @uri = 'https://tabelog.com'
    super
  end

  def perform
    puts 'start crawling'

    @page = @agent.get(@uri)
    self.search_keyword(@city)

    kus = self.get_areas

    kus.each do |ku|
      @ku = ku[:name]
      @page = @agent.get(ku[:uri])
      areas = self.get_areas

      self.create_list_file

      areas.each do |area|
        @area = area[:name]
        @page = @agent.get(area[:uri])
        self.scrape
      end
    end
  end

  def scrape
    loop do
      store_list = self.get_store_list

      stores = store_list.map do |store_element|
        self.get_store_info(store_element)
      end

      self.write(stores)

      break unless self.go_to_next_page
    end
  end


  # def scrape_narrow_down_store
  #   areas = self.get_areas
  #
  #   areas.each do |area|
  #     @page = @agent.get(area.uri)
  #     @area = area.name
  #
  #     @ku = @area
  #       self.create_list_file
  #       self.scrape_narrow_down_store
  #     else
  #       @ku = ''
  #       self.create_list_file
  #       self.scrape
  #     end
  #   end
  # end

  def get_areas
    area_lists = @page.search('ul.list-balloon__list-col')

    areas = []
    if area_lists.length > 1
      area_lists.each do |area_list|
        a_tags = area_list.search('a')
        a_tags.each do |a|
             areas.push({
                           name: a.text,
                           uri: a.attribute('href').value
                       })
          end
        end
    else
      a_tags = area_lists.search('a')
      a_tags.each do |a|
          areas.push({
                         name: a.text,
                         uri: a.attribute('href').value
                     })
      end
    end

    areas
  end

  def search_keyword(keyword)
    search_form = @page.form_with(name: 'FrmSrchFreeWord')
    search_form.sa = keyword
    @page = @agent.submit(search_form)
  end

  def go_to_next_page
    next_element = @page.search('.c-pagination__arrow--next')

    return false if next_element.length == 0

    @page = @agent.get(next_element.attribute('href').value)
    return true
  end


  def get_store_list
    @page.search("a.list-rst__rst-name-target")
  end

  def get_store_info(store_element)
    store = Store.new()

    store.url = store_element.attribute('href').value
    store_page = @agent.get(store.url)
    table =  store_page.search('table.c-table')
    rows = table.search('tr')

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

    store.area = @area

    store
  end

  def write(stores)
    CSV.open(@filepath,'a') do |file|
      stores.each do |store|
        file << [store.name, store.type, store.open_time, store.area, store.address, store.url]
      end
    end
  end

  def create_list_file
    filename = @uri.split("//")[1].split(".")[0]+'_'+@prefecture+'_'+@city+@ku
    extension = '.csv'
    path = './list/'
    @filepath = path+filename+extension

    CSV.open(@filepath,'w') do |file|
      file << ["店名", "ジャンル", "営業時間", "地域", "住所", "url"]
    end
  end
end
