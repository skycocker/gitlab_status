require 'webmock/rspec'

RSpec.describe GitlabStatus do
  it 'has a version number' do
    expect(GitlabStatus::VERSION).not_to be nil
  end
end

RSpec.describe GitlabStatus::HealthCheck do
  before  { WebMock.disable_net_connect!  }
  subject { GitlabStatus::HealthCheck.new }

  describe '.succeeded?' do
    context 'when the website is up and returns a 200 status code' do
      before do
        stub_request(:get, GitlabStatus::HealthCheck::TARGET_URL).to_return(status: 200)
      end

      it 'returns true' do
        expect(subject.succeeded?).to eq(true)
      end
    end

    context 'when the website is down because of a 500' do
      before do
        stub_request(:get, GitlabStatus::HealthCheck::TARGET_URL).to_return(status: 500)
      end

      it 'returns false' do
        expect(subject.succeeded?).to eq(false)
      end
    end

    context 'when the website is down because of a timeout' do
      before do
        stub_request(:get, GitlabStatus::HealthCheck::TARGET_URL).to_timeout
      end

      it 'returns false' do
        expect(subject.succeeded?).to eq(false)
      end
    end

    # webmock does not want to play with tyhphoeus/libcurl :/
    xcontext 'when the website returns a redirect' do
      let(:redirect_url) { 'https://somesubdomain.gitlab.com' }

      before do
        stub_request(:get, GitlabStatus::HealthCheck::TARGET_URL).to_return(
          status: 302,
          headers: { 'Location' => redirect_url },
        )

        stub_request(:get, redirect_url).to_return(status: 200)
      end

      it 'returns true' do
        expect(subject.succeeded?).to eq(true)
      end
    end
  end

  # we can't really easily stub the response time, so we just make sure there are no errors
  # (e.g. those stating that the method has not been implemented at all)
  describe '.response_time' do
    context 'when the website is up and returns a 200 status code' do
      before do
        stub_request(:get, GitlabStatus::HealthCheck::TARGET_URL).to_return(status: 200)
      end

      it 'does not throw errors' do
        expect { subject.response_time }.not_to raise_error
      end
    end

    context 'when the website is down because of a 500' do
      before do
        stub_request(:get, GitlabStatus::HealthCheck::TARGET_URL).to_return(status: 500)
      end

      it 'does not throw errors' do
        expect { subject.response_time }.not_to raise_error
      end
    end

    context 'when the website is down because of a timeout' do
      before do
        stub_request(:get, GitlabStatus::HealthCheck::TARGET_URL).to_timeout
      end

      it 'does not throw errors' do
        expect { subject.response_time }.not_to raise_error
      end
    end
  end
end
