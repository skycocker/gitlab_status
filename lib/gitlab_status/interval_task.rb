module GitlabStatus
  class IntervalTask
    # both args expressed in seconds
    def initialize(interval:, total_task_time:)
      @interval        = interval
      @total_task_time = total_task_time
      @task_start_time = nil
    end

    def run(&blk)
      @task_start_time = Time.now

      loop do
        iteration_start_time = Time.now

        yield

        remaining_sleep = interval_time_left_for(iteration_start_time)
        sleep(remaining_sleep) if remaining_sleep > 0

        break if expired?
      end
    end

    private

    def interval_time_left_for(iteration_start_time)
      @interval - (Time.now - iteration_start_time)
    end

    def expired?
      Time.now > (@task_start_time + @total_task_time)
    end
  end
end
