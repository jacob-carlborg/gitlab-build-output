require 'spec_helper'

describe GitLabBuildOutput::JobTracer do
  subject do
    GitLabBuildOutput::JobTracer.new(endpoint, private_token, git_repository)
  end

  let(:endpoint) { 'gitlab.com' }
  let(:private_token) { double(:private_token) }
  let(:git_repository) { nil }

  describe 'project_name' do
    let(:git_url) { 'git@gitlab.com:foo/bar.git' }

    before do
      allow(subject).to receive(:git_url).and_return(git_url)
    end

    def project_name
      subject.send(:project_name)
    end

    it 'returns the project name' do
      expect(project_name).to eq('foo/bar')
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
