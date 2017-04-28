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

  def can_accommodate_before_lunch?(meeting)
    meeting.duration <= capacity_left_before_lunch ? true : (schedule_lunch and false)
  end

  def can_accommodate_after_lunch?(meeting)
    meeting.duration <= capacity_left_after_lunch
  end

  def cannot_fit?(min_duration)
    capacity_left_before_lunch < min_duration && capacity_left_after_lunch < min_duration
  end

  def available_before_lunch?(meeting)
    @next_bookable_slot < lunch_start
  end

  def available_after_lunch?(meeting)
    @next_bookable_slot >= lunch_end && @next_bookable_slot < close_time
  end

  private

  def capacity_left_before_lunch
    original_capacity_before_lunch - @meetings.select {|x| x.start_time < @lunch_start }.inject(0) { |sum, m| sum + m.duration }
  end

  def capacity_left_after_lunch
    original_capacity_after_lunch - @meetings.select {|x| x.start_time < @close_time && x.start_time >= @lunch_end }.inject(0) { |sum, m| sum + m.duration }
  end

  def original_capacity_before_lunch
    (lunch_start - open_time).to_i/60
  end

  def original_capacity_after_lunch
    (close_time - lunch_end).to_i/60
  end

  def lunch_time
    (lunch_end - lunch_start).to_i/60
  end

end
