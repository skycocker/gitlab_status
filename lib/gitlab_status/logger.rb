require 'paint'

module GitlabStatus
  class Logger
    def initialize
      @probes = []
    end

    def log(probe)
      @probes << probe

      if probe.status
        log_successful_probe(probe)
      else
        log_failed_probe(probe)
      end
    end

    def log_average_time
      puts "Average successful response time: #{average_time} seconds"
    end

    private

    def log_successful_probe(probe)
      puts Paint%['%{status}, %{response_time} seconds', :default,
        status:        ['success', 'green'],
        response_time: [probe.response_time, 'default'],
      ]
    end

    def log_failed_probe(probe)
      puts Paint%['%{status}', :default,
        status: ['failure', 'red'],
      ]
    end

    def average_time
      # we only count the successful probes to the average.
      # there also is some place for an improvement regarding the first probe bias
      times = @probes.select(&:successful?).map(&:response_time)
      return 0 unless times.any?
      times.inject { |sum, el| sum + el }.fdiv(times.size)
    end
  end
end
