module TimeFormatHelper
  def format_time(t)
    t.strftime("%l:%M %P")
  end

  def format_time_with_day(t)
    t.strftime("%a, %l %P")
  end
end
