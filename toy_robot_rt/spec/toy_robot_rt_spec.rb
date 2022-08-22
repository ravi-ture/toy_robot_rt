# frozen_string_literal: true

RSpec.describe ToyRobotRt do
  describe ".execute" do
    it "initializes an object of ToyRobotRt" do
      toy_instance = instance_double(ToyRobotRt::Executor, execute: nil)
      allow(ToyRobotRt::Executor).to(receive(:new).and_return(toy_instance))

      expect(toy_instance).to(receive(:execute).once)

      ToyRobotRt::Executor.execute([])
    end

    context "invalid input" do
      let(:invalid_actions) { %w[JUMP DANCE] }
      let(:actions_without_place) { %w[MOVE RIGHT MOVE] }

      it "errors for blank actions" do
        expect { ToyRobotRt::Executor.execute([]) }.to(raise_error(StandardError, "No Commands"))
      end

      it "errors for invalid actions" do
        expect { ToyRobotRt::Executor.execute(invalid_actions) }.to(raise_error(StandardError, "Invalid Action: JUMP"))
      end

      it "errors if not placed" do
        expect do
          ToyRobotRt::Executor.execute(actions_without_place)
        end.to(raise_error(StandardError, "Robot not placed"))
      end

      it "errors if invalid placement" do
        expect do
          ToyRobotRt::Executor.execute(["PLACE 5,5,NORTH"])
        end.to(raise_error(StandardError, "Invalid Action: PLACE 5,5,NORTH"))
      end
    end

    context "valid inputs" do
      context "when all correct actions" do
        let(:streams) do
          {
            ["PLACE 0,0,NORTH"] => "0,0,NORTH",
            ["PLACE 0,0,EAST", "MOVE", "LEFT", "RIGHT"] => "0,1,EAST",
            ["PLACE 4,4,WEST", "MOVE", "LEFT", "LEFT"] => "4,3,EAST",
            ["PLACE 1,1,NORTH", "MOVE", "LEFT", "MOVE", "RIGHT"] => "2,0,NORTH",
            ["PLACE 4,4,SOUTH", "RIGHT", "MOVE", "LEFT", "MOVE", "RIGHT"] => "3,3,WEST",
            ["PLACE 0,0,SOUTH", "RIGHT", "RIGHT", "RIGHT", "RIGHT"] => "0,0,SOUTH",
            ["PLACE 0,4,NORTH", "LEFT", "MOVE", "RIGHT", "MOVE", "RIGHT"] => "1,3,EAST",
            ["PLACE 2,2,NORTH", "LEFT", "MOVE", "RIGHT", "MOVE", "RIGHT"] => "3,1,EAST",
            ["PLACE 4,0,SOUTH", "LEFT", "MOVE", "RIGHT", "MOVE", "MOVE"] => "2,1,SOUTH"
          }
        end
        it "works fine" do
          streams.each do |stream, output|
            instance = ToyRobotRt::Executor.new(stream)
            instance.execute
            expect(instance.status_string).to(eq(output))
          end
        end
      end

      context "when ignorable actions" do
        let(:streams) do
          {
            ["PLACE 4,0,WEST", "MOVE", "MOVE"] => "4,0,WEST",
            ["PLACE 4,0,NORTH", "MOVE", "MOVE"] => "4,0,NORTH",
            ["PLACE 0,0,SOUTH", "MOVE", "MOVE"] => "0,0,SOUTH",
            ["PLACE 0,0,SOUTH", "MOVE", "MOVE", "LEFT", "MOVE"] => "0,1,EAST",
            ["PLACE 1,0,WEST", "MOVE", "MOVE", "LEFT", "MOVE"] => "0,0,SOUTH",
            ["PLACE 4,4,EAST", "MOVE", "MOVE", "LEFT", "MOVE"] => "4,4,NORTH",
            ["PLACE 0,4,EAST", "MOVE", "MOVE", "LEFT", "MOVE"] => "1,4,NORTH"
          }
        end
        it "works fine" do
          streams.each do |stream, output|
            instance = ToyRobotRt::Executor.new(stream)
            instance.execute
            expect(instance.status_string).to(eq(output))
          end
        end
      end
    end
  end
end
