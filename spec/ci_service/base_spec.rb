require 'spec_helper'

describe GitLabBuildOutput::CiService::Base do
  let(:repositories) do
    GitLabBuildOutput.root.join('spec', 'fixtures', 'repositories')
  end

  def fixture(repository)
    repositories.join(repository)
  end

  describe '.from' do
    subject(:from) do
      described_class.from(repository: repository, private_token: nil)
    end

    let(:repository) { nil }

    context 'when the repository has a GitHub Actions configuration' do
      let(:repository) { fixture('github_actions') }

      it { is_expected.to be_a(GitLabBuildOutput::CiService::GithubActions) }
    end

    context 'when the repository has a GitLab configuration' do
      let(:repository) { fixture('gitlab') }

      it { is_expected.to be_a(GitLabBuildOutput::CiService::Gitlab) }
    end

    context 'when the repositories has no recognized CI service configuration' do
      let(:repository) { fixture('unrecognized') }

      it 'raises a CiService::UnrecognizedError exception' do
        error = GitLabBuildOutput::CiService::UnrecognizedError
        expect { from }.to raise_error(error)
      end
    end
  end
end
