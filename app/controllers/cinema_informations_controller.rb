require "open-uri"
require "kconv"
require "date"
# require "nokogiri"

class CinemaInformationsController < ApplicationController
  def home

    # DBからデータを検索
    today = Date.today.strftime("%Y-%m-%d")
    showing_record = CinemaShowing.where(date: today)
    # p "データ数は、#{showing_record.count}"
    if (showing_record.count == 0)
      # DBのデータを作成
      create_showing_record
      # DBからデータを再取得
      showing_record = CinemaShowing.where(date: today)
    end

    @infos = []
    # すでに@infosにデータを出力した映画のタイトルを保存
    # 本当は、映画のタイトルと上映スケジュールで、テーブルを分けておいたほうがよいと思う
    # ひとまずの対策
    checked_title = []
    showing_record.find_each do |record|
      next if checked_title.include?(record.title)

      info = CinemaInfo.new
      info.title = record.title
      checked_title << record.title
      showing_record.where(title: record.title).find_each do |each|
        info.add_start_time(each.start.strftime("%H:%M"))
      end
      @infos << info
    end

    # url = "https://www.jollios.net/cgi-bin/pc/site/det.cgi?tsc=21080"

    # # バイナリで読み込んで、文字化けを回避
    # html = open(url, "r:binary").read
    # doc = Nokogiri::HTML.parse(html.toutf8, nil, "utf-8")

    # @movies = doc.xpath("//div[@class='tTableSiteDet']")
    # @infos = []
    # @movies.each do |movie|
    #   info = CinemaInfo.new

    #   # 映画のタイトルの取り出し
    #   title = movie.xpath(".//div[@class='title']")
    #   title = title.xpath(".//a")
    #   info.title = title.text

    #   # 映画の開始時間の取り出し
    #   time_schedules = movie.xpath(".//div[contains(@id, 'sTime')]")
    #   time_schedules.each do |schedule|
    #     # モデルのオブジェクトを作成
    #     cinema_showing_record = CinemaShowing.new
    #     cinema_showing_record.title = info.title
    #     cinema_showing_record.date = Date.today.strftime("%Y-%m-%d")

    #     start_time = schedule.xpath(".//div[@class='start']").text
    #     info.add_start_time(start_time)
    #     cinema_showing_record.start = start_time
    #     cinema_showing_record.save
    #   end

    #   @infos << info
    # end
  end

  def create_showing_record
    # Webスクレイピングして、DBにデータを作成するメソッド
    url = "https://www.jollios.net/cgi-bin/pc/site/det.cgi?tsc=21080"

    # バイナリで読み込んで、文字化けを回避
    html = open(url, "r:binary").read
    doc = Nokogiri::HTML.parse(html.toutf8, nil, "utf-8")

    movies = doc.xpath("//div[@class='tTableSiteDet']")
    # @infos = []
    movies.each do |movie|
      # info = CinemaInfo.new

      # 映画のタイトルの取り出し
      title = movie.xpath(".//div[@class='title']")
      title = title.xpath(".//a")
      # info.title = title.text

      # 映画の開始時間の取り出し
      time_schedules = movie.xpath(".//div[contains(@id, 'sTime')]")
      time_schedules.each do |schedule|
        # モデルのオブジェクトを作成
        cinema_showing_record = CinemaShowing.new
        cinema_showing_record.title = title.text
        cinema_showing_record.date = Date.today.strftime("%Y-%m-%d")

        start_time = schedule.xpath(".//div[@class='start']").text
        # info.add_start_time(start_time)
        cinema_showing_record.start = start_time
        cinema_showing_record.save
      end

      # @infos << info
    end
  end

  def api
    url = "https://www.jollios.net/cgi-bin/pc/site/det.cgi?tsc=21080"

    # バイナリで読み込んで、文字化けを回避
    html = open(url, "r:binary").read
    doc = Nokogiri::HTML.parse(html.toutf8, nil, "utf-8")

    movies = doc.xpath("//div[@class='tTableSiteDet']")
    json_data = []
    movies.each do |movie|
      info = {}

      # 映画のタイトルの取り出し
      title = movie.xpath(".//div[@class='title']")
      title = title.xpath(".//a")
      info[:title] = title.text

      # 映画の開始時間の取り出し
      time_schedules = movie.xpath(".//div[contains(@id, 'sTime')]")
      info[:schedule] = []
      lateshow_flag = false
      time_schedules.each do |schedule|
        start_time = schedule.xpath(".//div[@class='start']").text
        info[:schedule] << start_time
        lateshow_flag = true if start_time.to_i >= 20
      end

      # レイトショーの有無を設定
      info[:lateshow] = lateshow_flag

      json_data << info
    end
    render :json => json_data
  end
end
