require "spec_helper"
require_relative "../meeting"
require_relative "../room"

describe Room do

  context "invalid instantation" do
    it "should raise exception" do
      expect { Room.new }.to raise_error(ArgumentError)
    end
  end

  describe "creation" do
    describe "#name" do
      subject { Room.new("Room 1") }

      it "has a name" do
        expect(subject).to respond_to(:name)
        expect(subject.name).to eq("Room 1")
      end

      it "does not allow to change name" do
        expect{ subject.name = "Room 2" }.to raise_error(NoMethodError)
        expect(subject.name).to eq("Room 1")
      end
    end

    describe "#open_time" do
      let(:current_time) { Time.now }
      subject { Room.new("Room 1", current_time) }

      it "has a open_time" do
        expect(subject).to respond_to(:open_time)
        expect(subject.open_time.hour).to eq(9)
      end

      it "does not allow change of open time" do
        expect{ subject.open_time = Time.now }.to raise_error(NoMethodError)
      end
    end

    describe "#close_time" do
      let(:current_time) { Time.now }
      subject { Room.new("Room 1", current_time) }

      it "has a close_time" do
        expect(subject).to respond_to(:close_time)
        expect(subject.close_time.hour).to eq(17)
      end

      it "does not allow change of close_time" do
        expect{ subject.close_time = Time.now }.to raise_error(NoMethodError)
      end
    end

    describe "#next_bookable_slot" do
      subject { Room.new("Room 1") }

      it "has a next_bookable_slot by default" do
        expect(subject).to respond_to(:next_bookable_slot)
        expect(subject.next_bookable_slot).to eq(subject.open_time)
      end

      it "does allows change of next_bookable_slot" do
        subject.next_bookable_slot = subject.open_time + 3600
        expect(subject.next_bookable_slot).to eq(subject.open_time + 3600)
      end
    end
  end

  describe "#meetings" do
    let(:meeting) { Meeting.new("Meeting Title", 30) }
    let(:room) { Room.new("Room 1") }

    context "upon room creation" do
      it "should have meetings attribute" do
        expect(room).to respond_to(:meetings)
      end

      it "should not have any meetings assgined" do
        expect(room.meetings).to be_empty
      end
    end

    context "meetings are allocated to the room" do
      before { room.book!(meeting) }

      it "should have a meetings set" do
        expect(room.meetings).to include(meeting)
      end
    end
  end

  describe "#book" do
    let(:meeting) { Meeting.new("Meeting Title", 30) }
    let(:room) { Room.new("Room 1") }

    it "should book a meeting" do
      room.book!(meeting)

      expect(room.meetings).to_not be_empty
      expect(room.meetings).to include(meeting)
    end

    xit "should assign a start time to the meeting" do
      room.book!(meeting)
    end

    it "should change next_bookable_slot" do
      expect { room.book!(meeting) }.to change{ room.next_bookable_slot }
    end
  end

  describe "#schedule_lunch" do
    let(:meeting) { Meeting.new("Meeting Title", 30) }
    let(:room) { Room.new("Room 1") }

    it "should add a lunch meeting to the room" do
      expect { room.schedule_lunch }.to change {room.meetings.count }.by(1)
    end

    it "should change the next bookable slot to lunch end" do
      expect { room.schedule_lunch }.to change {room.next_bookable_slot.hour }.to(13)
    end
  end

end
