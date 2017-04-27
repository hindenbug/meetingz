require "set"

class Room

  attr_accessor :meetings, :next_bookable_slot
  attr_reader :name, :open_time, :close_time, :lunch_start, :lunch_end

  def initialize(name, current_time=Time.now)
    @name         = name
    @meetings     = Set.new

    @open_time    = Time.new(current_time.year, current_time.month, current_time.day, 9, 0)
    @close_time   = Time.new(current_time.year, current_time.month, current_time.day, 17, 0)
    @lunch_start  = Time.new(current_time.year, current_time.month, current_time.day, 12, 0)
    @lunch_end    = Time.new(current_time.year, current_time.month, current_time.day, 13, 0)

    @next_bookable_slot = @open_time
  end

  def book!(meeting)
    meeting.start_time = @next_bookable_slot
    @meetings.add(meeting)
    meeting.room = name
    @next_bookable_slot += meeting.duration * 60
    return true
  end

  def schedule_lunch
    lunch = Meeting.new('Lunch', 60)
    lunch.start_time = lunch_start
    @meetings.add(lunch)
    @next_bookable_slot = lunch_end
  end

end
