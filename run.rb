require_relative "meeting"
require_relative "room"
require_relative "allocator"

file = ARGV[0]

meetings = []
rooms = []

rooms << Room.new("MR 1")
rooms << Room.new("MR 2")


File.readlines(file).each do |line|
  agenda, duration = line.strip.split(/\s* (\d+)/)
  meetings << Meeting.new(agenda, duration)
end

allocator = Allocator.new(rooms, meetings)
allocator.allocate!

allocator.print_chart
