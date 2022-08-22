# frozen_string_literal: true

module ToyRobotRt
  # Validatison required for toy's actions
  module ActionsValidator
    private

    def check_action_list
      acceptable_actions?
      toy_placed?
    end

    def acceptable_actions?
      raise StandardError, "No Commands" if @actions.nil? || @actions.empty?

      @actions.each do |action|
        next if action.match?(/PLACE [0-4],[0-4],((NORTH)|(SOUTH)|(EAST)|(WEST))/)
        next if %w[MOVE RIGHT LEFT REPORT].include?(action)

        raise StandardError, "Invalid Action: #{action}"
      end
    end

    def toy_placed?
      place_action = @actions.find { |a| a.match(/PLACE [0-4],[0-4],((NORTH)|(SOUTH)|(EAST)|(WEST))/) }
      return unless place_action.nil?

      raise StandardError, "Robot not placed"
    end
  end
end
