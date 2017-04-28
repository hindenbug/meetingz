require "spec_helper"
require_relative "../allocator"
require_relative "../meeting"
require_relative "../room"

describe Allocator do

  let(:meetings) { [
    Meeting.new("Meeting 1", "60"),
    Meeting.new("Meeting 2", "45"),
  ] }

  let(:rooms) { [ Room.new("Room 1"), Room.new("Room 2") ] }

  describe "#allocate!" do
    let(:allocator) { Allocator.new(rooms, meetings) }
    let(:open_time) { Time.new(Time.now.year, Time.now.month, Time.now.day, 9, 0) }

    before do
      allow_any_instance_of(Room).to receive(:open_time).and_return(open_time)
      allow_any_instance_of(Room).to receive(:lunch_start).and_return(open_time + 60 *60)
      allow_any_instance_of(Room).to receive(:close_time).and_return(open_time + 180 * 60)
    end

    it "should allocate all meetings to rooms" do
      allocator.allocate!

      expect(meetings).to be_empty
      rooms.each_with_index do |room, i|
        expect(room.meetings).to_not be_empty
      end
    end

    it "should try and allocate all meetings" do
      meetings.push(Meeting.new("Meeting 3", "45"))

      allocator.allocate!

      expect(meetings).to_not be_empty

      rooms.each_with_index do |room, i|
        expect(room.meetings).to_not be_empty
      end

      expect(meetings).to include(meetings.last)
    end
  end


end
