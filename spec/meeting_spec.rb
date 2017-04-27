require "spec_helper"
require_relative "../meeting"

describe Meeting do

  context "invalid instantation" do
    it "should raise exception" do
      expect { Meeting.new }.to raise_error(ArgumentError)
    end
  end

  context "valid instantiation" do
    describe "#agenda" do
      subject { Meeting.new("Meeting Title", "30") }

      it "has an agenda" do
        expect(subject).to respond_to(:agenda)
        expect(subject.agenda).to eq("Meeting Title")
      end

      it "does not allow to change agenda" do
        expect{ subject.agenda = "New Agenda" }.to raise_error(NoMethodError)
        expect(subject.agenda).to eq("Meeting Title")
      end
    end

    describe "#duration" do
      subject { Meeting.new("Meeting Title", "30") }

      it "has a duration" do
        expect(subject).to respond_to(:duration)
        expect(subject.duration).to eq(30)
      end

      it "does not allow to change duration" do
        expect{ subject.duration = 60 }.to raise_error(NoMethodError)
        expect(subject.duration).to eq(30)
      end
    end

    describe "#start_time" do
      subject { Meeting.new("Meeting Title", "30") }

      it "should be nil" do
        expect(subject).to respond_to(:start_time)
        expect(subject.start_time).to be_nil
      end
    end

    describe "#room" do
      subject { Meeting.new("Meeting Title", "30") }

      it "should be nil" do
        expect(subject).to respond_to(:room)
        expect(subject.room).to be_nil
      end
    end

    context "room allocated to the meeting" do
      let(:meeting) { Meeting.new("Meeting Title", 30) }
      let(:room) { Room.new("Room 1") }

      before { room.book!(meeting) }

      it "should have a start time set" do
        expect(meeting.start_time).to_not be_nil
        expect(meeting.start_time).to be_a_kind_of(Time)
      end

      it "should have room allocated" do
        expect(meeting.room).to eq(room.name)
      end

      it "succesfully prints the meeting details with schedule" do
        expect(meeting.to_s).to match("09:00AM Meeting Title 30min")
      end
    end
  end

end
