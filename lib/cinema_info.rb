class CinemaInfo
  attr_accessor :title, :start_times
  def initialize
    @title = ""
    @start_times = []
  end

  def add_start_time(time)
    @start_times << time
  end

end