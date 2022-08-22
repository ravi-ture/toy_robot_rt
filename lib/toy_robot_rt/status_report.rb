# frozen_string_literal: true

module ToyRobotRt
  # prints the toy's status in X,Y,FACING format
  module StatusReport
    def status_string
      [x, y, facing].join(",")
    end

    private

    def report_status
      puts status_string
    end
  end
end
