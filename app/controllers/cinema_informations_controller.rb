require "open-uri"
require "kconv"
# require "nokogiri"

class CinemaInformationsController < ApplicationController
  def home
    url = "https://www.jollios.net/cgi-bin/pc/site/det.cgi?tsc=21080"

    # バイナリで読み込んで、文字化けを回避
    html = open(url, "r:binary").read
    doc = Nokogiri::HTML.parse(html.toutf8, nil, "utf-8")

    @movies = doc.xpath("//div[@class='tTableSiteDet']")
    @infos = []
    @movies.each do |movie|
      info = CinemaInfo.new

      # 映画のタイトルの取り出し
      title = movie.xpath(".//div[@class='title']")
      title = title.xpath(".//a")
      info.title = title.text

      # 映画の開始時間の取り出し
      time_schedules = movie.xpath(".//div[contains(@id, 'sTime')]")
      time_schedules.each do |schedule|
        start_time = schedule.xpath(".//div[@class='start']").text
        info.add_start_time(start_time)
      end

      @infos << info
    end
    # @movies = doc.xpath("//div[@class='tTableSiteDet']")
    # p @movies
  end
end
