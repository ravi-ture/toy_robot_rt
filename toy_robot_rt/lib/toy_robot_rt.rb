# frozen_string_literal: true

require_relative "toy_robot_rt/actions_validator"
require_relative "toy_robot_rt/actions_performer"
require_relative "toy_robot_rt/status_report"

module ToyRobotRt
  # Parent class to handle everything needed for executing a single stream of commands
  class Executor
    include ActionsValidator
    include ActionsPerformer
    include StatusReport

    attr_reader :actions, :facing, :x, :y

    def initialize(actions_list)
      @actions = actions_list
      @facing = @x = @y = nil
    end

    def self.read_actions(file_path)
      begin
        actions_list = File.readlines(file_path).collect(&:strip)
      rescue StandardError => e
        puts "Error while reading file: #{e.message}"
      end
      new(actions_list).execute
    end

    def self.execute(actions_list)
      new(actions_list).execute
    end

    def execute
      check_action_list
      execute_actions
    end
  end
end
