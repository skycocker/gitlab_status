RSpec.describe GitlabStatus::HealthCheck::Probe do
  subject { GitlabStatus::HealthCheck::Probe }

  describe '.new' do
    it 'requires two arguments' do
      expect { subject.new            }.to     raise_error(ArgumentError)
      expect { subject.new(true)      }.to     raise_error(ArgumentError)
      expect { subject.new(true, 1.2) }.not_to raise_error
    end
  end

  context 'for successful probe' do
    subject { GitlabStatus::HealthCheck::Probe.new(true, 1.2) }

    describe '.status' do
      it 'returns true' do
        expect(subject.status).to eq(true)
      end
    end

    describe '.successful?' do
      it 'returns true' do
        expect(subject.successful?).to eq(true)
      end
    end

    describe '.response_time' do
      it 'returns 1.2' do
        expect(subject.response_time).to eq(1.2)
      end
    end
  end

  context 'for non-successful probe' do
    subject { GitlabStatus::HealthCheck::Probe.new(false, nil) }

    describe '.status' do
      it 'returns false' do
        expect(subject.status).to eq(false)
      end
    end

    describe '.successful?' do
      it 'returns false' do
        expect(subject.successful?).to eq(false)
      end
    end

    describe '.response_time' do
      it 'returns nil' do
        expect(subject.response_time).to eq(nil)
      end
    end
  end
end
