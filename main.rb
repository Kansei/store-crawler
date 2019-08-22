require_relative './class/tabelog_crawler'
require_relative './class/store'

prefecture = '福岡県'
city = '福岡市'

crawler = TabelogCrawler.new(prefecture: prefecture, city: city)
crawler.perform

