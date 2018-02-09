require 'gitlab_status/interval_task'

RSpec.describe GitlabStatus::IntervalTask do
  describe '.run' do
    subject { GitlabStatus::IntervalTask.new(interval: 1, total_task_time: 2) }

    it 'runs given block specified interval (number of times), breaking after its multiplication to total_time' do
      initial_counter = 0

      subject.run do
        initial_counter = initial_counter.next
      end

      expect(initial_counter).to eq(2)
    end
  end
end
