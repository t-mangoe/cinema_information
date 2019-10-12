require "open-uri"
require "kconv"
# require "nokogiri"

class CinemaInformationsController < ApplicationController
  def home
    url = "https://www.jollios.net/cgi-bin/pc/site/det.cgi?tsc=21080"


    # バイナリで読み込んで、文字化けを回避
    html = open(url, 'r:binary').read
    doc = Nokogiri::HTML.parse(html.toutf8, nil, 'utf-8')
    p doc.title
    all = doc.xpath("//*")
    # p all
    # p doc.xpath("//div[@id='wrapper']")
    @movies = doc.xpath("//div[@class='tTableSiteDet']")
    # @movies = doc.xpath("//div[@class='tTableSiteDet']")
    # p @movies
  end
end
