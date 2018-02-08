require 'typhoeus'
require 'pry'
require 'active_support/all'

module GitlabStatus
  class HealthCheck
    TARGET_URL = 'https://about.gitlab.com'.freeze

    def initialize
      prepare
      request.run
    end

    def succeeded?
      response.success?
    end

    def response_time
      response.total_time
    end

    private

    attr_accessor :response

    def prepare
      request.on_complete(&method(:response=))
    end

    def request
      @request ||= Typhoeus::Request.new(TARGET_URL, followlocation: true)
    end
  end
end
