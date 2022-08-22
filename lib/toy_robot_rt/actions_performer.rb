# frozen_string_literal: true

module ToyRobotRt
  # Performs place, move and turn actions
  module ActionsPerformer
    DIRECTIONS = %w[SOUTH WEST NORTH EAST].freeze

    private

    # rubocop:disable Metrics/MethodLength
    def execute_actions
      @actions.clone.each do |action|
        case action
        when /PLACE [0-4],[0-4],((NORTH)|(SOUTH)|(EAST)|(WEST))/
          place(action)
        when "MOVE"
          move
        when "RIGHT", "LEFT"
          turn(action)
        when "REPORT"
          report_status
        end
        @actions.shift
      end
    end
    # rubocop:enable Metrics/MethodLength

    def place(action)
      cords = action.gsub("PLACE ", "").split(",")
      @x = cords.first.to_i
      @y = cords[1].to_i
      @facing = cords.last
    end

    def move
      raise StandardError, "Cannot move without placing" if @facing.nil? || @x.nil? || @y.nil?

      send("move_#{@facing.downcase}") if %w[NORTH SOUTH EAST WEST].include?(@facing)
    end

    def move_north
      @x += 1 if @x < 4
      # Ignored a NORTH move
    end

    def move_south
      @x -= 1 if @x.positive?
      # Ignored a SOUTH move
    end

    def move_east
      @y += 1 if @y < 4
      # Ignored an EAST move
    end

    def move_west
      @y -= 1 if @y.positive?
      # Ignored a NORTH move
    end

    def turn(action)
      raise StandardError, "Cannot turn without placing" if @facing.nil? || @x.nil? || @y.nil?

      current_index = DIRECTIONS.index(@facing)
      @facing = if action == "RIGHT"
                  DIRECTIONS.rotate[current_index]
                else
                  DIRECTIONS.rotate(-1)[current_index]
                end
    end
  end
end
