require 'spec_helper'

describe GitLabBuildOutput::JobTracer do
  subject do
    GitLabBuildOutput::JobTracer.new(private_token, git_repository, endpoint)
  end

  let(:endpoint) { 'gitlab.com' }
  let(:private_token) { double(:private_token) }
  let(:git_repository) { nil }

  describe 'endpoint=' do
    shared_examples 'endpoint' do
      it 'inferes the endpoint based on the Git URL' do
        expect(subject.send(:endpoint=, given_endpoint)).to eq(expected)
      end
    end

    context 'when the given endpoint is not null' do
      let(:given_endpoint) { endpoint }

      it 'sets the endpoint as is' do
        expect(subject.send(:endpoint=, given_endpoint)).to eq(endpoint)
      end
    end

    context 'when the given endpoint is null' do
      let(:git_url) { "git@#{endpoint}:foo/bar.git" }
      let(:given_endpoint) { nil }

      before do
        allow(subject).to receive(:git_url).and_return(git_url)
      end

      context 'when the Git URL is using the SSH protocol' do
        let(:git_url) { "ssh://git@#{endpoint}/foo/bar.git" }
        let(:expected) { "http://#{endpoint}/api/v3" }
        include_examples 'endpoint'
      end

      context 'when the Git URL is using the SSH protocol with the SCP like ' \
        'syntx' do

        let(:git_url) { "git@#{endpoint}:foo/bar.git" }
        let(:expected) { "http://#{endpoint}/api/v3" }
        include_examples 'endpoint'
      end

      context 'when the Git URL is using the HTTP protocol' do
        let(:git_url) { "http://#{endpoint}/foo/bar.git" }
        let(:expected) { "http://#{endpoint}/api/v3" }
        include_examples 'endpoint'
      end

      context 'when the Git URL is using the HTTPS protocol' do
        let(:git_url) { "https://#{endpoint}/foo/bar.git" }
        let(:expected) { "https://#{endpoint}/api/v3" }
        include_examples 'endpoint'
      end

      context 'when no .git suffix is included' do
        let(:git_url) { "http://#{endpoint}/foo/bar" }
        let(:expected) { "http://#{endpoint}/api/v3" }
        include_examples 'endpoint'
      end
    end

    # def endpoint=(endpoint)
    #   return @endpoint = endpoint if endpoint.present?
    #   uri = URI.parse(parsed_url.host)
    #
    #   if uri.host.blank? && uri.path.present?
    #     uri.host = uri.path
    #     uri.path = '/api/v3'
    #     uri.scheme ||= scheme
    #   end
    #
    #   @endpoint = uri.to_s
    # end
  end

  describe 'project_name' do
    let(:project_name) { 'foo/bar' }

    before do
      allow(subject).to receive(:git_url).and_return(git_url)
    end

    shared_examples 'project name' do
      it 'returns the project name' do
        expect(subject.send(:project_name)).to eq(project_name)
      end
    end

    context 'when the Git URL is using the SSH protocol' do
      let(:git_url) { "ssh://git@gitlab.com/#{project_name}.git" }
      include_examples 'project name'
    end

    context 'when the Git URL is using the SSH protocol with the SCP like ' \
      'syntx' do

      let(:git_url) { "git@gitlab.com:#{project_name}.git" }
      include_examples 'project name'
    end

    context 'when the Git URL is using the HTTP protocol' do
      let(:git_url) { "http://gitlab.com/#{project_name}.git" }
      include_examples 'project name'
    end

    context 'when the Git URL is using the HTTPS protocol' do
      let(:git_url) { "https://gitlab.com/#{project_name}.git" }
      include_examples 'project name'
    end

    context 'when no .git suffix is included' do
      let(:git_url) { "http://gitlab.com/#{project_name}" }
      include_examples 'project name'
    end
  end

  describe 'parsed_url' do
    let(:git_url) { 'git@gitlab.com:foo/bar.git' }

    before do
      allow(subject).to receive(:git_url).and_return(git_url)
    end

    def parsed_url
      subject.send(:parsed_url)
    end

    it 'returns the project name' do
      expect(parsed_url).to be_a(URI::SshGit::Generic)
    end
  end
end
