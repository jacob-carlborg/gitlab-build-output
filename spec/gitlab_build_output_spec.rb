require 'spec_helper'

describe GitLabBuildOutput do
  it 'has a version number' do
    expect(GitLabBuildOutput::VERSION).not_to be nil
  end
end
