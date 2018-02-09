require 'thor'

require 'gitlab_status/interval_task'
require 'gitlab_status/logger'
require 'gitlab_status/health_check'

module GitlabStatus
  class CLI < Thor
    desc 'perform', 'Performs a health check of https://about.gitlab.com for a minute with 10-second probes'
    def perform
      task   = GitlabStatus::IntervalTask.new(interval: 10, total_task_time: 60)
      logger = GitlabStatus::Logger.new

      task.run do
        probe = GitlabStatus::HealthCheck.new.probe
        logger.log(probe)
      end

      logger.log_average_time
    end
  end
end
