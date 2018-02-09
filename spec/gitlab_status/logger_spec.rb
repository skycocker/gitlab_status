require 'gitlab_status/logger'

RSpec.describe GitlabStatus::Logger do
  let(:logger)               { GitlabStatus::Logger }
  let(:successful_probe)     { GitlabStatus::HealthCheck::Probe.new(true, 1.2)  }
  let(:successful_probe_2)   { GitlabStatus::HealthCheck::Probe.new(true, 1.5)  }
  let(:non_successful_probe) { GitlabStatus::HealthCheck::Probe.new(false, nil) }

  subject { logger.new }

  # no need for any excessive output
  before { allow($stdout).to receive(:puts) }

  describe '.log' do
    context 'for successful probe' do
      it 'writes a successful notice and the total time' do
        expect($stdout).to receive(:puts).with(include('success', '1.2'))
        subject.log(successful_probe)
      end
    end

    context 'for non-successful probe' do
      it 'writes a failed notice' do
        expect($stdout).to receive(:puts).with(include('failure'))
        subject.log(non_successful_probe)
      end
    end
  end

  describe '.log_average_time' do
    context 'with only successful probes provided first' do
      before do
        5.times { subject.log(successful_probe)   }
        5.times { subject.log(successful_probe_2) }
      end

      it 'writes an average response time' do
        expect($stdout).to receive(:puts).with('Average successful response time: 1.35 seconds')
        subject.log_average_time
      end
    end

    context 'with only non-successful probes provided first' do
      before do
        10.times { subject.log(non_successful_probe)   }
      end

      it 'writes an average response time (being 0 though)' do
        expect($stdout).to receive(:puts).with('Average successful response time: 0 seconds')
        subject.log_average_time
      end
    end

    context 'with mixed successful and non-successful probes provided first' do
      before do
        5.times { subject.log(successful_probe)     }
        5.times { subject.log(non_successful_probe) }
      end

      it 'writes an average response time, regarding only the successful probes' do
        expect($stdout).to receive(:puts).with('Average successful response time: 1.2 seconds')
        subject.log_average_time
      end
    end
  end
end
