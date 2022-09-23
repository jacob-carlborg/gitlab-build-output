require 'base64'
require 'erb'
require 'json'
require 'ostruct'
require 'pathname'
require 'set'
require 'stringio'
require 'strscan'

require 'git'
require 'gitlab'
require 'git_clone_url'
require 'httparty'
require 'octokit'

require 'gitlab_build_output/core_ext'

require 'gitlab_build_output/ansi2html'
require 'gitlab_build_output/application'
require 'gitlab_build_output/gitlab_api'
require 'gitlab_build_output/html_outputter'
require 'gitlab_build_output/job_tracer'
require 'gitlab_build_output/outputter'
require 'gitlab_build_output/tracer'
require 'gitlab_build_output/version'

require 'gitlab_build_output/ci_service/base'
require 'gitlab_build_output/ci_service/unrecognized_error'

require 'gitlab_build_output/ci_service/github_actions'
require 'gitlab_build_output/ci_service/gitlab'

# the order of these are important
require 'gitlab_build_output/single_runner'
require 'gitlab_build_output/loop_runner'

module GitLabBuildOutput
  def self.root
    @root ||= Pathname.new(File.dirname(__FILE__)).join('..')
  end
end
