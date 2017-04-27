class Meeting

  attr_reader   :agenda, :duration
  attr_accessor :start_time, :room

  def initialize(agenda, duration)
    @agenda = agenda
    @duration = duration.to_i
  end

  def to_s
    if @start_time
      "#{@start_time.strftime('%I:%M%p')} #{agenda} #{duration}min"
    else
      "____ #{agenda} #{duration}min"
    end
  end

end
