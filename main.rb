require_relative './class/tabelog_crawler'
require_relative './class/store'

prefecture = '福岡'
areas = ['大名(福岡県 福岡市中央区)', '博多駅', '天神駅', '赤坂駅（福岡県）']

areas.each do |area|
  pp 'start crawling '+area
  crawler = TabelogCrawler.new(prefecture: prefecture, area: area)
  crawler.perform
end

