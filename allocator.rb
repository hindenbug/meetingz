class Allocator

  def initialize(rooms, meetings)
    @rooms = rooms
    @meetings = meetings
    meetings_group = meetings.group_by { |m| m.duration } rescue {}
    @smallest_meeting = meetings_group.keys.min
    @meetings_m = []
  end

  def allocate!
    @rooms.each do |room|
      while @meetings.any?
        break if room.cannot_fit?(@smallest_meeting)

        meeting = @meetings.shift
        if room.available_before_lunch?(meeting)
          room.can_accommodate_before_lunch?(meeting) ? room.book!(meeting) : @meetings.push(meeting)
        elsif room.available_after_lunch?(meeting)
          room.can_accommodate_after_lunch?(meeting) ? room.book!(meeting) : @meetings.push(meeting)
        end
      end
    end
  end

  def print_chart
    @rooms.each_with_index do |room, i|
      puts "Room :#{i}"
      room.meetings.each { |m| puts m }
    end
  end

end
