module GitlabStatus
  class HealthCheck
    class Probe
      attr_reader :status, :response_time
      alias_method :successful?, :status

      def initialize(status, response_time)
        @status        = status
        @response_time = response_time
      end
    end
  end
end
